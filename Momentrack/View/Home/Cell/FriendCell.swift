//
//  FriendCell.swift
//  Momentrack
//
//  Created by heyji on 2024/07/15.
//

import UIKit

final class FriendCell: UICollectionViewCell {
    
    static let identifier: String = "FriendCell"
    
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.clipsToBounds = true
        view.layer.cornerRadius = 45 / 2
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
//        view.layer.masksToBounds = false
//        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
//        view.layer.shadowOffset = .zero
//        view.layer.shadowOpacity = 1
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(nickname: String) {
        titleLabel.text = nickname
    }
    
    private func setupCell() {
        addSubview(cellView)
        cellView.addSubview(titleLabel)
        
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
