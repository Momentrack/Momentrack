//
//  LoginView.swift
//  Momentrack
//
//  Created by Nat Kim on 7/11/24.
//

import UIKit
import SnapKit

class LoginView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    lazy var emailButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("이메일", for: .normal)
        return button
    }()
    
    private func setupUI() {
        self.addSubview(emailButton)
        emailButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}

