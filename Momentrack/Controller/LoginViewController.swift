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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        validateInputs()
    }
    
    func validateInputs() {
        guard let email = loginView.emailTextField.text,
              let password = loginView.passwordTextField.text else {
            return
        }
        
        let isEmailValid = User.isValidEmail(id: email)
        let isPasswordValid = User.isValidPassword(pwd: password)
        
        loginView.passwordErrorLabel.isHidden = isPasswordValid
        loginView.loginButton.isEnabled = isEmailValid && isPasswordValid
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
        if !User.isValidPassword(pwd: password) {
            loginView.passwordErrorLabel.isHidden = false
            return
        } else {
            loginView.passwordErrorLabel.isHidden = true
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn called")
        textField.resignFirstResponder()
        return true
    }
}
