//
//  SharingManager.swift
//  Momentrack
//
//  Created by Nat Kim on 7/29/24.
//

import UIKit

protocol Shareable {
    func shareLocationByAddress(_ address: String, from viewController: UIViewController)
    func shareLocationByCoordinates(latitude: Double, longitude: Double, locationName: String, from viewController: UIViewController)
    func shareImage(_ image: UIImage, from viewController: UIViewController)
}

class SharingManager: Shareable {
    static let shared = SharingManager()
    
    private init() {}
    
    func shareLocationByAddress(
        _ address: String, 
        from viewController: UIViewController
    ) {
        guard !address.isEmpty else {
            print("주소가 없습니다.")
            return
        }
        
        let mapURLString = "https://maps.apple.com/?q=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        guard let mapURL = URL(string: mapURLString) else {
            print("유효하지 않은 URL입니다.")
            return
        }
        
        presentShareSheet(with: [mapURL], from: viewController)
    }
    
    func shareLocationByCoordinates(
        latitude: Double,
        longitude: Double,
        locationName: String,
        from viewController: UIViewController
    ) {
        let mapsString = "http://maps.apple.com/?q=\(latitude),\(longitude)"
        presentShareSheet(with: [locationName, mapsString], from: viewController)
    }
    
    func shareImage(
        _ image: UIImage,
        from viewController: UIViewController
    ) {
        presentShareSheet(with: [image], from: viewController)
    }
    
    private func presentShareSheet(
        with items: [Any],
        from viewController: UIViewController
    ) {
        let activityViewController = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(
                x: viewController.view.bounds.midX,
                y: viewController.view.bounds.midY,
                width: 0,
                height: 0
            )
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
}
