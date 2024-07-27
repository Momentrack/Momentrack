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
    private let sharingLocationService = SharingLocationService()
    
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
        postingMomentView.shareLocationBtn.addTarget(self, action: #selector(shareLocationButtonTapped), for: .touchUpInside)
    }
    
    @objc func pinnedCurrentLocation(_ sender: UIButton) {
        let mapVC = MapViewController()
        mapVC.currentLocationAddress = postingMomentView.addressLabel.text
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
    
    @objc func shareLocationButtonTapped() {
        guard let address = postingMomentView.addressLabel.text else { return }
        sharingLocationService.shareLocation(address: address, presenter: self, sourceView: postingMomentView.shareLocationBtn)
    }
    
    @objc func handleImageTap() {
        if postingMomentView.uploadPhoto.image != nil {
            postingMomentView.uploadPhoto.image = nil
            postingMomentView.cameraButton.isHidden = false
        }
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
            }
        }
    }
    
   

}

extension UIViewController {
    func alert(_ message: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel) { (_) in
                completion?() // completion 매개변수의 값이 nil이 아닐때에만 실행되도록
            }
            alert.addAction(okAction)
            self.present(alert, animated: false)
        }
    }
}

extension PostingMomentViewController: MapViewControllerDelegate {
    func didSelectLocationWithAddress(_ address: String?) {
        if let address = address {
            postingMomentView.addressLabel.text = address
        }
    }
    
    func dismissMapViewController() {
        dismiss(animated: true, completion: nil)
    }
}
