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
  
    override func loadView() {
        view = postingMomentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        setTargetActions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setTargetActions() {
        postingMomentView.cameraButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        postingMomentView.currentLocationBtn.addTarget(self, action: #selector(pinnedCurrentLocation), for: .touchUpInside)
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
    
    
}

extension PostingMomentViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let itemprovider = results.first?.itemProvider{
            
            if itemprovider.canLoadObject(ofClass: UIImage.self){
                
                itemprovider.loadObject(ofClass: UIImage.self) { image , error  in
                    if let selectedImage = image as? UIImage{
                        DispatchQueue.main.async {
                            self.postingMomentView.uploadPhoto.image = selectedImage
                        }
                    }
                }
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
//    func selectPhotoLibrary(src: UIImagePickerController.SourceType) {
//        if UIImagePickerController.isSourceTypeAvailable(src) {
//            let picker = UIImagePickerController()
//            picker.delegate = self
//            picker.allowsEditing = true
//
//            self.present(picker, animated: false)
//        } else {
//            self.alert("사용할 수 없는 타입입니다.")
//        }
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let rawVal = UIImagePickerController.InfoKey.originalImage.rawValue
//        if let image = info[UIImagePickerController.InfoKey(rawValue: rawVal)] as? UIImage {
//            let imageData = image.jpegData(compressionQuality: 0.1)!
//            self.imageData = imageData
//
//            let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
//            let imageName = imageUrl?.lastPathComponent
//            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
//            let appendingPath = documentDirectory?.appending("/")
//            let localPath = appendingPath?.appending(imageName!)
//            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//            let data = image.pngData()! as NSData
//            data.write(toFile: localPath!, atomically: true)
//            self.moment.photoUrl = localPath!
//            //self.updateSnapshot()
//        }
//        self.dismiss(animated: true)
//    }
