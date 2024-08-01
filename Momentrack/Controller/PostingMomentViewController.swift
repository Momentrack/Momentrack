//
//  PostingMomentViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/21/24.
//

import UIKit
import PhotosUI

class PostingMomentViewController: UIViewController {
    private let postingMomentView = PostingMomentView()
    
    var moment: Moment?
    private let momentId =  UUID().uuidString
    
    var imageData: Data = Data()
    var imageUrl: String = ""
    
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    
    override func loadView() {
        view = postingMomentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        setTargetActions()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
            postingMomentView.uploadPhoto.addGestureRecognizer(tapGesture)
            postingMomentView.uploadPhoto.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setTargetActions() {
        postingMomentView.cameraButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        postingMomentView.currentLocationBtn.addTarget(self, action: #selector(pinnedCurrentLocation), for: .touchUpInside)
        postingMomentView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func pinnedCurrentLocation(_ sender: UIButton) {
        let mapVC = MapViewController()
        mapVC.selectedLocationAddress = postingMomentView.addressLabel.text
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
        if postingMomentView.uploadPhoto.image != nil {
            postingMomentView.uploadPhoto.image = nil
            postingMomentView.cameraButton.isHidden = false
        }
    }
    
    @objc func saveButtonTapped() {
        guard let location = postingMomentView.addressLabel.text, !location.isEmpty else {
            showAlert(message: "위치를 선택해주세요.")
            return
        }
        
        guard let memo = postingMomentView.momentTextView.text, !memo.isEmpty else {
            showAlert(message: "텍스트를 입력해주세요.")
            return
        }
        let sharedFriends = postingMomentView.withFriends.friendList.isEmpty ? ["나"] : postingMomentView.withFriends.friendList
        
        if self.moment?.photoUrl != self.imageUrl {
            Network.shared.imageUpload(storageName: "moments", id: momentId, imageData: imageData) { url in
                
                if self.moment?.location != "" {
                    self.moment?.photoUrl = url
                    print("테스트, 이미지 업로드 완료. URL: \(url)")
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
                self.postingMomentView.uploadPhoto.image = selectedImage
                self.postingMomentView.cameraButton.isHidden = true
                
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
            postingMomentView.addressLabel.text = address
            self.latitude = latitude
            self.longitude = longitude
            
        }
    }
    
    func dismissMapViewController() {
        dismiss(animated: true, completion: nil)
    }
}

extension Notification.Name {
    static let momentSaved = Notification.Name("momentSaved")
}

