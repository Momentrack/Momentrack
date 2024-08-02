//
//  CalendarHeaderView.swift
//  Momentrack
//
//  Created by heyji on 2024/07/24.
//

import UIKit

final class CalendarHeaderView: UICollectionReusableView {
    
    static let identifier: String = "CalendarHeaderView"
    
    private let titleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .pastelBlueJean.withAlphaComponent(0.8)
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
    private func setupView() {
        addSubview(titleLineView)
        addSubview(titleLabel)
        
        titleLineView.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.top.equalTo(titleLabel.snp.top).offset(14)
            make.left.equalTo(titleLabel.snp.left).offset(-8)
            make.right.equalTo(titleLabel.snp.right).offset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
