//
//  SharingLocationService.swift
//  Momentrack
//
//  Created by Nat Kim on 7/28/24.
//

import UIKit

class SharingLocationService {
    func shareLocation(address: String, presenter: UIViewController, sourceView: UIView?) {
        guard !address.isEmpty else {
            print("주소가 없습니다.")
            return
        }
        
        let mapURLString = "https://maps.apple.com/?q=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        guard let mapURL = URL(string: mapURLString) else {
            print("유효하지 않은 URL입니다.")
            return
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: [mapURL],
            applicationActivities: nil
        )
        
        presenter.present(activityViewController, animated: true, completion: nil)
    }
}
