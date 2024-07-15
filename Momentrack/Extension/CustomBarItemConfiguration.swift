//
//  CustomBarItemConfiguration.swift
//  Momentrack
//
//  Created by heyji on 2024/07/15.
//

import UIKit

struct CustomBarItemConfiguration {
    typealias Action = () -> Void
    
    let title: String?
    let image: UIImage?
    let action: Action
    
    init(title: String? = nil, image: UIImage? = nil, action: @escaping Action) {
        self.title = title
        self.image = image
        self.action = action
    }
}

final class CustomBarItem: UIButton {
    
    var customBarItemConfig: CustomBarItemConfiguration
    
    init(cofing: CustomBarItemConfiguration) {
        self.customBarItemConfig = cofing
        super.init(frame: .zero)
        setupStyle()
        updateConfig()
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupStyle() {
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        self.setTitleColor(.label, for: .normal)
        self.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        self.imageView?.tintColor = .label
    }
    
    private func updateConfig() {
        self.setTitle(customBarItemConfig.title, for: .normal)
        self.setImage(customBarItemConfig.image, for: .normal)
    }
    
    @objc func buttonTapped() {
        customBarItemConfig.action()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIBarButtonItem {
    static func generate(with config: CustomBarItemConfiguration, width: CGFloat? = nil) -> UIBarButtonItem {
        let customView = CustomBarItem(cofing: config)
        
        if let width = width {
            NSLayoutConstraint.activate([
                customView.widthAnchor.constraint(equalToConstant: width)
            ])
        }
        
        let barButtonItem = UIBarButtonItem(customView: customView)
        return barButtonItem
    }
}
