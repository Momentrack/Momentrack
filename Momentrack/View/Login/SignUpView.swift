//
//  SignUpView.swift
//  Momentrack
//
//  Created by Nat Kim on 8/4/24.
//

import UIKit
import SnapKit

final class SignUpView: UIView {
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
        textField.attributedPlaceholder = NSAttributedString(string: "6~8자리, 소문자, 특수문자1개, 숫자1개", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        
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
    
    lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 조건은 6~8자리 이하 특수문자 1개, 숫자 1개여야합니다."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    

    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightBlueJean
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("회원가입", for: .normal)
        return button
    }()

    private func setupUI() {
        self.addSubview(logo)
        self.addSubview(maillabel)
        self.addSubview(emailTextField)
        self.addSubview(passwordlabel)
        self.addSubview(passwordTextField)
        self.addSubview(passwordErrorLabel)
        self.addSubview(signUpButton)
        
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

        signUpButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
            $0.top.equalTo(passwordTextField).offset(120)
        }
    }
}

//MARK: - Preview Setting
#if DEBUG
import SwiftUI

struct SwiftUISignUpView: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> some UIView {
        return SignUpView()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISignUpView()
            .previewLayout(.sizeThatFits)
    }
}
#endif


