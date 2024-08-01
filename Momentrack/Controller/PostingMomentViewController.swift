//
//  PostingMomentViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/21/24.
//

import UIKit
import PhotosUI

class PostingMomentViewController: UIViewController {
    //private let postingMomentView = PostingMomentView()

    var moment: Moment?
    private let momentId =  UUID().uuidString
    var imageData: Data = Data()
    var imageUrl: String = ""
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0

    
    weak var textViewDelegate: UITextViewDelegate?
    var friendDelegate: AddFriendDelegate?
    var selectedFriends: [String] = []
    var friendList: [String] = []
    
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
        button.tintColor = .black
        button.addTarget(self, action: #selector(pinnedCurrentLocation), for: .touchUpInside)
        return button
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        //label.text = "테스트 주소입니다."
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.blue
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
        button.tintColor = .black
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
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    
    private func setupView() {
        view.addSubview(currentLocationStack)
        //self.addSubview(shareLocationBtn)
        view.addSubview(addressLabel)
        view.addSubview(withFriendLabel)
        view.addSubview(collectionView)
        collectionView.register(SelectedFriendCell.self, forCellWithReuseIdentifier: SelectedFriendCell.identifier)
        
        collectionView.alwaysBounceVertical = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        view.addSubview(photoLabel)
        view.addSubview(uploadPhoto)
        uploadPhoto.addSubview(cameraButton)
        
        view.addSubview(writingLabel)
        view.addSubview(momentTextView)
        momentTextView.placeholderText = "당신의 여정을 기록해보세요."
        
        view.addSubview(saveButton)
        
        currentLocationStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(16)
        }

        addressLabel.snp.makeConstraints {
            $0.top.equalTo(currentLocationStack.snp.top).offset(32)
            $0.left.equalTo(currentLocationLabel.snp.left)
        }
        
        withFriendLabel.snp.makeConstraints {
            $0.top.equalTo(currentLocationStack.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(withFriendLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        photoLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(30)
            $0.left.equalTo(withFriendLabel.snp.left)
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
            $0.left.equalTo(photoLabel)
            $0.top.equalTo(uploadPhoto.snp.bottom).offset(19)
        }
        
        momentTextView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.top.equalTo(writingLabel.snp.bottom).offset(8)
            //$0.bottom.equalTo(saveButton.snp.top).offset(12)
            $0.height.greaterThanOrEqualTo(100)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
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
            Network.shared.imageUpload(storageName: "moments", id: momentId, imageData: imageData) { url in
                
                if self.moment?.location != "" {
                    self.moment?.photoUrl = url
                    self.saveMoment(location: location, photoUrl: url, memo: memo, sharedFriends: sharedFriends)

                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlert(message: "위치버튼을 클릭해주세요.")
                }
                
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
