//
//  LoginView.swift
//  Momentrack
//
//  Created by Nat Kim on 7/11/24.
//

import UIKit
import SnapKit

class LoginView: UIView {
    weak var textFieldDelegate: UITextFieldDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var logo: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "logo_02")
        logoImage.contentMode = .scaleAspectFit
        logoImage.tintColor = .label
        return logoImage
    }()
    
    private lazy var maillabel: UILabel = {
        let title = UILabel()
        title.text = "이메일 인증"
        title.font = .systemFont(ofSize: 16)
        title.textColor = .label
        return title
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        
        let leftInsetView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
        textField.leftView = leftInsetView
        textField.leftViewMode = .always
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.attributedPlaceholder = NSAttributedString(string: "example@example.com", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        
        textField.layer.cornerRadius = 10
        textField.keyboardType = .default
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        
        textField.returnKeyType = .done
        textField.layer.backgroundColor = UIColor.systemGray6.cgColor
        
        return textField
    }()
    
    lazy var loginStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authButton, loginButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        //stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightBlueJean
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("로그인", for: .normal)
        return button
    }()
    
    lazy var authButton: UIButton = {
        let button = UIButton()
        button.setTitle("이메일로 인증하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.label, for: .normal)
        button.setUnderline()
        return button
    }()
    
    private func setupUI() {
        self.addSubview(logo)
        self.addSubview(maillabel)
        self.addSubview(emailTextField)
        self.addSubview(loginStack)

        logo.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(60)
            $0.left.right.equalToSuperview().inset(80)
            $0.height.equalTo(120)
        }
        
        maillabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.top).offset(-32)
            $0.left.equalTo(emailTextField.snp.left).inset(8)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(80)
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(24)
        }
        
        loginStack.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(86)
        }
       
        loginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalTo(loginStack).inset(16)
            $0.height.equalTo(48)
            
        }
        
    }
}

//MARK: - Preview Setting
#if DEBUG
import SwiftUI

struct SwiftUILoginView: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> some UIView {
        return LoginView()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUILoginView()
            .previewLayout(.sizeThatFits)
    }
}
#endif

