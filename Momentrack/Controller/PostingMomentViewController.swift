//
//  PostingMomentViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/21/24.
//

import UIKit
import PhotosUI
import SnapKit

class PostingMomentViewController: UIViewController {

    var moment: Moment?
    private let momentId =  UUID().uuidString
    var imageData: Data?
    var imageUrl: String = ""
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0

    
    weak var textViewDelegate: UITextViewDelegate?
    var friendDelegate: AddFriendDelegate?
    var selectedFriends: [String] = []
    var friendList: [String] = []
    
    // 스크롤뷰 추가
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    // 컨텐츠뷰 추가
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var withFriendLabel: UILabel = {
        let label = UILabel()
        label.text = "함께한 사람 선택"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        return collectionView
    }()
    
    lazy var currentLocationStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentLocationLabel, currentLocationBtn])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    

    lazy var currentLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 위치"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    lazy var currentLocationBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(pinnedCurrentLocation), for: .touchUpInside)
        return button
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        //label.text = "테스트 주소입니다."
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor.lightBlueJean
        return label
    }()
    
    lazy var photoLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 등록"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    lazy var uploadPhoto: UIImageView = {
        let photo = UIImageView()
        photo.backgroundColor = .systemGray5
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        photo.isUserInteractionEnabled = true
        
        return photo
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
        button.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        button.tintColor = .label
        return button
    }()
    
    lazy var writingLabel: UILabel = {
        let label = UILabel()
        label.text = "글 등록"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label

        return label
    }()
    
    lazy var momentTextView: MomentTextView = {
        let textView = MomentTextView()
        textView.delegate = textViewDelegate
        return textView
    }()
    
    lazy var keyboardAccessoryView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        view.backgroundColor = UIColor.lightBlueJean
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("글 작성완료", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.lightBlueJean
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        //setTargetActions()
        setupView()
        
        getUserInfo()
        

        self.friendDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        momentTextView.inputAccessoryView = keyboardAccessoryView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(currentLocationStack)
        contentView.addSubview(addressLabel)
        contentView.addSubview(withFriendLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(photoLabel)
        contentView.addSubview(uploadPhoto)
        uploadPhoto.addSubview(cameraButton)
        contentView.addSubview(writingLabel)
        contentView.addSubview(momentTextView)
       
        view.addSubview(saveButton)
        
        collectionView.register(SelectedFriendCell.self, forCellWithReuseIdentifier: SelectedFriendCell.identifier)
        
        collectionView.alwaysBounceVertical = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        momentTextView.placeholderText = "당신의 여정을 기록해보세요."
        setupConstraints()
      
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            //$0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        currentLocationStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(currentLocationStack.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        withFriendLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(withFriendLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        photoLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(30)
            $0.left.equalTo(withFriendLabel)
        }
        
        uploadPhoto.snp.makeConstraints {
            $0.top.equalTo(photoLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(160)
        }
        
        cameraButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        writingLabel.snp.makeConstraints {
            $0.top.equalTo(uploadPhoto.snp.bottom).offset(19)
            $0.left.equalTo(photoLabel)
        }
        
        momentTextView.snp.makeConstraints {
            $0.top.equalTo(writingLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(100)
            $0.bottom.equalToSuperview().inset(120) // 여백 추가
        }
        
        saveButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            //$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            //$0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets

            if momentTextView.isFirstResponder {
                let activeRect = momentTextView.convert(momentTextView.bounds, to: scrollView)
                scrollView.scrollRectToVisible(activeRect, animated: true)
            }
     
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(45), heightDimension: .absolute(45))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(45), heightDimension: .absolute(45))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    @objc func pinnedCurrentLocation(_ sender: UIButton) {
        let mapVC = MapViewController()
        mapVC.selectedLocationAddress = addressLabel.text
        mapVC.mapDelegate = self
        mapVC.isModalInPresentation = true
        mapVC.modalPresentationStyle = .popover
        self.present(mapVC, animated: true) {
            mapVC.requestLocationPermission()
            mapVC.checkAccuracyAuthorization()
        }
    }

    @objc func addImageButtonTapped() {
        configureImagePicker()
    }
    
    func configureImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let pickerViewController = PHPickerViewController(configuration: configuration)
        
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
   
    @objc func handleImageTap() {
        if uploadPhoto.image != nil {
            uploadPhoto.image = nil
            cameraButton.isHidden = false
        }
    }
    
    @objc func saveButtonTapped() {
        guard let location = addressLabel.text, !location.isEmpty else {
            showAlert(message: "위치를 선택해주세요.")
            return
        }
        
        guard let memo = momentTextView.text, !memo.isEmpty else {
            showAlert(message: "텍스트를 입력해주세요.")
            return
        }
        let sharedFriends = selectedFriends.isEmpty ? ["나"] : selectedFriends
        if self.moment?.photoUrl != self.imageUrl {
            guard let imageData else {
                self.saveMoment(location: location, photoUrl: "", memo: memo, sharedFriends: sharedFriends)
                
                self.dismiss(animated: true)
                return
            }
            Network.shared.imageUpload(storageName: "moments", id: momentId, imageData: imageData) { url in
                self.moment?.photoUrl = url
                self.saveMoment(location: location, photoUrl: url, memo: memo, sharedFriends: sharedFriends)
                
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            saveMoment(location: location, photoUrl: "", memo: memo, sharedFriends: sharedFriends)
        }
    }
    
    private func saveMoment(location: String, photoUrl: String, memo: String, sharedFriends: [String]) {
        
        Network.shared.createMoment(
            location: location,
            photoUrl: photoUrl,
            memo: memo,
            sharedFriends: sharedFriends,
            latitude: self.latitude,
            longitude: self.longitude
        )
        
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: .momentSaved, object: nil)
            }
        }
        
    }
    
    private func getUserInfo() {
        Network.shared.getUserInfo { user in
            if user.friends.contains(user.email) {
                let friends = user.friends
                self.friendList = friends.filter { $0 != user.email }
            }
            self.collectionView.reloadData()
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension PostingMomentViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self, let selectedImage = image as? UIImage else { return }
            DispatchQueue.main.async {
                self.uploadPhoto.image = selectedImage
                self.cameraButton.isHidden = true
                
                if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                    self.imageData = imageData
                }
            }
        }
    }
    
   

}


extension PostingMomentViewController: MapViewControllerDelegate {
    func didSelectLocationWithCoordinate(_ address: String?, latitude: Double, longitude: Double) {
        if let address = address {
            addressLabel.text = address
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    func dismissMapViewController() {
        dismiss(animated: true, completion: nil)
    }
}



extension PostingMomentViewController: AddFriendDelegate {
    func action(indexPath: IndexPath) {
        if indexPath.item < friendList.count {
            let selectedFriend = friendList[indexPath.item]
            if let index = selectedFriends.firstIndex(of: selectedFriend) {
                selectedFriends.remove(at: index)
            } else {
                selectedFriends.append(selectedFriend)
                
            }
            self.selectedFriends = [selectedFriend]
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}

extension Notification.Name {
    static let momentSaved = Notification.Name("momentSaved")
}


extension PostingMomentViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return friendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedFriendCell.identifier, for: indexPath) as! SelectedFriendCell
            let friend = friendList[indexPath.item]
            cell.withFriendsconfigure(nickname: String(friendList[indexPath.item].first!), isSelected: selectedFriends.contains(friend))
            
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectedFriendCell else {
            return
        }
        let friend = friendList[indexPath.item]
        if let index = selectedFriends.firstIndex(of: friend) {
            selectedFriends.remove(at: index)
            cell.isSelected = false
        } else {
            selectedFriends.append(friend)
            cell.isSelected = true
        }

    }
}

