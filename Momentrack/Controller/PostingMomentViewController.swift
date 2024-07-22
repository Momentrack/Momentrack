//
//  PostingMomentViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/21/24.
//

import UIKit

class PostingMomentViewController: UICollectionViewController {
    
    var momentInfo: MomentInfo {
        didSet {
            onChange(momentInfo)
        }
    }
    
    var savingMomentInfo: MomentInfo
    var isAddingNewInfo = false
    var onChange: (MomentInfo) -> Void
    let imageURL: String
    var imageData: Data = Data()
    
    init(momentInfo: MomentInfo, onChange: @escaping (MomentInfo) -> Void) {
        self.momentInfo = momentInfo
        self.savingMomentInfo = momentInfo
        self.onChange = onChange
        self.imageURL = momentInfo.photo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateSnapshot() {
        
    }
}

extension PostingMomentViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @objc func didTappedImageButton() {
        selectPhotoOptions(.photoLibrary)
    }
    
    func selectPhotoOptions(_ source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            
            self.present(picker, animated: true)
        } else {
            self.alert("사용할 수 없는 사진유형입니다.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let rawVal = UIImagePickerController.InfoKey.originalImage.rawValue
        if let image = info[UIImagePickerController.InfoKey(rawValue: rawVal)] as? UIImage {
            let imageData = image.jpegData(compressionQuality: 0.1)!
            self.imageData = imageData
            
            let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
            let imageName = imageUrl?.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let appendingPath = documentDirectory?.appending("/")
            let localPath = appendingPath?.appending(imageName!)
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            self.momentInfo.photo = localPath!
            self.updateSnapshot()
        }
        self.dismiss(animated: true)
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
