//
//  LoginEmailPwView.swift
//  Momentrack
//
//  Created by Nat Kim on 8/3/24.
//

import UIKit
import SnapKit

final class LoginEmailPwView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
        title.text = "이메일"
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
        textField.tag = 0
        return textField
    }()
    
    private lazy var passwordlabel: UILabel = {
        let title = UILabel()
        title.text = "비밀번호"
        title.font = .systemFont(ofSize: 16)
        title.textColor = .label
        return title
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        
        let leftInsetView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
        textField.leftView = leftInsetView
        textField.leftViewMode = .always
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.attributedPlaceholder = NSAttributedString(string: "6~8자리 이하 영소문자, 숫자조합", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        
        textField.layer.cornerRadius = 10
        textField.keyboardType = .default
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.layer.backgroundColor = UIColor.systemGray6.cgColor
        textField.tag = 1 
        return textField
    }()
    
    lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 조건은 6~8자리 이하 영소문자, 숫자조합이여야합니다."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .red
        label.isHidden = true
        return label
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
    
    lazy var signUpLabel: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.label, for: .normal)
        button.setUnderline()
        return button
    }()

    private func setupUI() {
        self.addSubview(logo)
        self.addSubview(maillabel)
        self.addSubview(emailTextField)
        self.addSubview(passwordlabel)
        self.addSubview(passwordTextField)
        self.addSubview(passwordErrorLabel)
        self.addSubview(loginButton)
        self.addSubview(signUpLabel)
        
        logo.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(60)
            $0.left.right.equalToSuperview().inset(80)
            $0.height.equalTo(120)
        }
        
        maillabel.snp.makeConstraints {
            $0.top.equalTo(logo.snp.top).offset(160)
            $0.left.equalTo(emailTextField.snp.left).inset(8)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(maillabel.snp.bottom).offset(16)
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(24)
        }
        
        passwordlabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(16)
            $0.left.equalTo(emailTextField.snp.left).inset(8)
        }
        
        passwordErrorLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8)
            $0.left.right.equalTo(passwordTextField)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordlabel.snp.bottom).offset(16)
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(24)
        }

        loginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
            $0.top.equalTo(passwordTextField).offset(120)
        }
        
        signUpLabel.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
}

//MARK: - Preview Setting
#if DEBUG
import SwiftUI

struct SwiftUILoginEmailPwView: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> some UIView {
        return LoginEmailPwView()
    }
}

struct LoginEmailPwView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUILoginEmailPwView()
            .previewLayout(.sizeThatFits)
    }
}
#endif

