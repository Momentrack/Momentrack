//
//  SignUpViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 8/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class SignUpViewController: BaseViewController {
    private let signUpView = SignUpView()
    
    override func loadView() {
        view = signUpView
        signUpView.emailTextField.delegate = self
        signUpView.passwordTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setTargetAction()
        
        //self.hideKeyboardWhenTappedAround()
        
        // Navigation bar 설정
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .black // Back 버튼 색상 설정
        title = "회원가입하기"
        navigationItem.largeTitleDisplayMode = .never
        
        // Back 버튼 설정
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    @objc func backButtonTapped() {
        AppController.shared.routeToLogin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 다시 로그인 화면으로 돌아갈 때 네비게이션 바 숨기기
        if isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func setTargetAction() {
        signUpView.signUpButton.addTarget(self, action: #selector(didTappedSignUpBtn), for: .touchUpInside)
        signUpView.emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        signUpView.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        validateInputs()
    }
    
    func validateInputs() {
        guard let email = signUpView.emailTextField.text,
              let password = signUpView.passwordTextField.text else {
            return
        }
        
        let isEmailValid = User.isValidEmail(id: email)
        let isPasswordValid = User.isValidPassword(pwd: password)
        
        signUpView.passwordErrorLabel.isHidden = isPasswordValid
        signUpView.signUpButton.isEnabled = isEmailValid && isPasswordValid
    }
    
    
    @objc func didTappedSignUpBtn() {
        guard let email = signUpView.emailTextField.text, !email.isEmpty else {
            showAlert(message: "이메일을 입력해주세요")
            return
        }
        guard let password = signUpView.passwordTextField.text, !password.isEmpty else {
            showAlert(message: "비밀번호를 입력해주세요")
            return
        }

        print("Attempting to sign in with email: \(email)") // 디버그 프린트 추가
        if !User.isValidPassword(pwd: password) {
            signUpView.passwordErrorLabel.isHidden = false
            return
        } else {
            signUpView.passwordErrorLabel.isHidden = true
        }
        
        registerUser(email: email, password: password)
    }
    
    fileprivate func registerUser(email: String, password: String) {
        guard let email = signUpView.emailTextField.text else { return }
        guard let password = signUpView.passwordTextField.text else { return }
        Network.shared.createUserInfo(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.showAlert(message: "회원가입이 완료되었습니다!", completion: {
                        AppController.shared.routeToLogin()
                    })
                case .failure(let error):
                    self?.showAuthAlert(message: "\(error.localizedDescription)")
                }
            }
        }
      
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn called")
        textField.resignFirstResponder()
        return true
    }
}

