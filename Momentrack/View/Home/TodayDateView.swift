//
//  TodayDateView.swift
//  Momentrack
//
//  Created by heyji on 2024/07/16.
//

import UIKit

final class TodayDateView: UIView {
    
    private let titleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemCyan.withAlphaComponent(0.6)
        return view
    }()
    
    private var todayLabel: UILabel = {
        let label = UILabel()
        label.text = Date().todayStringFormat
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLineView)
        addSubview(todayLabel)
        
        titleLineView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(todayLabel.snp.top).offset(10)
            make.left.equalTo(todayLabel.snp.left)
            make.right.equalTo(todayLabel.snp.right)
        }
        todayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
