//
//  DayCell.swift
//  Momentrack
//
//  Created by heyji on 2024/07/25.
//

import UIKit

final class DayCell: UICollectionViewCell {
    
    static let identifier: String = "DayCell"
    
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBlueJean
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
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
    
    func configure(day: String, imageUrl: String? = nil) {
        titleLabel.text = day
        guard let imageUrl else { return }
        mainImageView.setImageURL(imageUrl)
    }
    
    private func setupCell() {
        addSubview(cellView)
        cellView.addSubview(mainImageView)
        mainImageView.addSubview(titleLabel)
        
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
