//
//  AddFriendCell.swift
//  Momentrack
//
//  Created by heyji on 2024/07/29.
//

import UIKit

final class AddFriendCell: UICollectionViewCell {
    
    static let identifier: String = "AddFriendCell"

    private let cellView: UIView = {
        let view = UIView(frame: CGRect(x: .zero , y: .zero, width: 45, height: 45))
        
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = nil
        layer.lineDashPattern = [2, 2]
        layer.lineWidth = 0.5
        
        let path = UIBezierPath()
        let point1 = CGPoint(x: view.bounds.midX, y: view.bounds.minY)
        let point2 = CGPoint(x: view.bounds.midX, y: view.bounds.maxY)
        
        path.move(to: point1)
        path.addLine(to: point2)
        
        layer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 45 / 2).cgPath
        view.layer.addSublayer(layer)
        return view
    }()
    
    let titleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.setTitle("+", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        addSubview(cellView)
        cellView.addSubview(titleButton)
        
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
