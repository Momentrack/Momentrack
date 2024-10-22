//
//  SelectedFriendCell.swift
//  Momentrack
//
//  Created by Nat Kim on 8/1/24.
//

import UIKit

class SelectedFriendCell: UICollectionViewCell {
    static let identifier: String = "SelectedFriendCell"
    
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 45 / 2
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
   
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
    
    func withFriendsconfigure(nickname: String, isSelected: Bool = false) {
        titleLabel.text = nickname
        self.isSelected = isSelected
        updateAppearance()
    }
    
    private func updateAppearance() {
        if isSelected {
            cellView.backgroundColor = UIColor.lightBlueJean
            titleLabel.textColor = .white
            titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        } else {
            cellView.backgroundColor = .white
            titleLabel.textColor = .black
        }
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
