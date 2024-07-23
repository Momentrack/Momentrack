//
//  PostingMomentViewController+CellConfiguration.swift
//  Momentrack
//
//  Created by Nat Kim on 7/21/24.
//

import UIKit

extension PostingMomentViewController {
    func titleConfiguration(for cell: UICollectionViewListCell, with title: String) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .title3)
        return contentConfiguration
    }
    
    func imageConfiguration(for cell: UICollectionViewListCell, with image: String?) -> ImageContentView.Configuration {
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTappedImageButton)
        )
        
        cell.addGestureRecognizer(gesture)
        var contentConfiguration = cell.imageConfiguration()
        contentConfiguration.image = image
        contentConfiguration.onChange = { [weak self] image in
            self?.momentInfo.photo = image
        }
        return contentConfiguration
    }
    
    
}
