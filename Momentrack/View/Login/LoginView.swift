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
        logoImage.image = UIImage(systemName: "airplane.circle.fill")
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
        //let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 48))
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
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("로그인", for: .normal)
        return button
    }()
    
    private func setupUI() {
        self.addSubview(logo)
        self.addSubview(maillabel)
        self.addSubview(emailTextField)
        self.addSubview(loginButton)
        logo.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(60)
            $0.left.right.equalToSuperview().inset(54)
            $0.height.equalTo(160)
        }
        
        maillabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.top).offset(-32)
            $0.left.equalTo(emailTextField.snp.left).inset(8)
        }
        
        emailTextField.snp.makeConstraints {
            $0.bottom.equalTo(loginButton.snp.top).offset(-42)
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(24)
        }
        
        loginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(320)
            $0.left.right.equalToSuperview().inset(24)
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
