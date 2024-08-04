//
//  LoginViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/11/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: BaseViewController {
    
    private let loginView = LoginEmailPwView()
    
    override func loadView() {
        view = loginView
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        setupTextFields(emailTextField: loginView.emailTextField, passwordTextField: loginView.passwordTextField)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setTargetAction()
        
        //self.hideKeyboardWhenTappedAround()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func setTargetAction() {
        loginView.emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        loginView.loginButton.addTarget(self, action: #selector(didTappedLoginBtn), for: .touchUpInside)
        loginView.signUpLabel.addTarget(self, action: #selector(didTappedSignUpBtn), for: .touchUpInside)
    }
    
    @objc override func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 1 {
            validateInputs(emailTextField: loginView.emailTextField,
                           passwordTextField: loginView.passwordTextField,
                           passwordErrorLabel: loginView.passwordErrorLabel,
                           actionButton: loginView.loginButton)
        } else {
            loginView.loginButton.isEnabled = User.isValidEmail(id: loginView.emailTextField.text ?? "") &&
            User.isValidPassword(pwd: loginView.passwordTextField.text ?? "")
        }
    }
    
    @objc func didTappedSignUpBtn() {
        AppController.shared.routeToSignUp()
    }
    
    @objc func didTappedLoginBtn() {
        guard let email = loginView.emailTextField.text else {
            showAlert(message: "이메일을 입력해주세요")
            return
        }
        guard let password = loginView.passwordTextField.text else {
            showAlert(message: "비밀번호를 입력해주세요")
            return
        }

        print("Attempting to sign in with email: \(email)") // 디버그 프린트 추가
        let isPasswordValid = User.isValidPassword(pwd: password)
        loginView.passwordErrorLabel.isHidden = isPasswordValid
        
        if !isPasswordValid {
            return
        }
        
        Network.shared.signInApp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    AppController.shared.setHome()
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            }
        }
        
        view.endEditing(true)
    }
}

