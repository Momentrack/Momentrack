//
//  LoginViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/11/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //private let loginView = LoginView()
    private let loginView = LoginEmailPwView()
    var userModel = UserModel()
    
    override func loadView() {
        view = loginView
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setTargetAction()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func setTargetAction() {
        loginView.loginButton.addTarget(self, action: #selector(didTappedLoginBtn), for: .touchUpInside)
        loginView.emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
        
        AppController.shared.signInOrSignUp(email: email, password: password) { success, message in
                if success {
                    print(message ?? "로그인/회원가입 성공")
                    // 여기서 추가적인 작업을 수행할 수 있습니다.
                } else {
                    self.showAlert(message: message ?? "알 수 없는 오류가 발생했습니다.")
                }
            }
        // 먼저 로그인 시도
        /*
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error as NSError? {
                // 로그인 실패 시 회원가입 시도
                if error.code == AuthErrorCode.userNotFound.rawValue {
                    // 회원가입
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print("회원가입 실패: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                self?.showAlert(message: "회원가입 실패: \(error.localizedDescription)")
                            }
                        } else {
                            print("회원가입 및 로그인 성공")
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
                            }
                        }
                    }
                } else {
                    print("로그인 실패: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self?.showAlert(message: "로그인 실패: \(error.localizedDescription)")
                    }
                }
            } else {
                print("로그인 성공")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
                }
            }
        }
        */
        /*
        Network.shared.signInApp(email: email, password: password) { result in
            switch result {
            case .success(let message):
                self.showAlert(message: "로그인 성공: \(message)")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
                }
            case .failure(let error):
                print("로그인/회원가입 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(message: "로그인/회원가입 실패: \(error.localizedDescription)")
                }
            }
        }
        */
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
  
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn called")
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


/*
 Network.shared.signInApp(email: email) { result in
     switch result {
     case .success(let success):
         print(success)
         DispatchQueue.main.async {
             let homeVC = HomeViewController()
             let navigationController = UINavigationController(rootViewController: homeVC)
             
             if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first {
                 window.rootViewController = navigationController
                 window.makeKeyAndVisible()
                 
                 
                 UIView.transition(with: window,
                                   duration: 0.3,
                                   options: .transitionCrossDissolve,
                                   animations: nil,
                                   completion: nil)
             }
         }
         
     case .failure(let error):
         print(error)
     }
 }
 */

/*
 func loginCheck(id: String, pwd: String) -> Bool {
     for user in userModel.users {
         if user.email == id && user.password == pwd {
             return true
         }
     }
     return false
 }
 
 @objc func didEndOnExit(_ sender: UITextField) {
     if loginView.emailTextField.isFirstResponder {
         loginView.passwordTextField.becomeFirstResponder()
     }
 }
 
 */

/*
 @objc func appMovedToForeground() {
     checkAuthStatus()
 }
 
 func checkAuthStatus() {
     if let link = UserDefaults.standard.string(forKey: "Link") {
         
         showToastMessage("인증 완료했습니다. 로그인 버튼을 클릭해주세요")
         
         UserDefaults.standard.removeObject(forKey: "Link")
     }
 }
 
 private func showToastMessage(_ message: String) {
     let toastLabel = UILabel()
     toastLabel.backgroundColor = .systemGray.withAlphaComponent(0.8)
     toastLabel.textColor = .white
     toastLabel.font = .systemFont(ofSize: 12)
     toastLabel.textAlignment = .center
     toastLabel.text = message
     toastLabel.layer.cornerRadius = 8
     toastLabel.clipsToBounds = true
     
     self.view.addSubview(toastLabel)
     toastLabel.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.bottom.equalToSuperview().inset(100)
         make.width.equalTo(335)
         make.height.equalTo(30)
     }
     
     UIView.animate(withDuration: 3, delay: 1.5, options: .curveEaseOut) {
         toastLabel.alpha = 0.0
     } completion: { isCompleted in
         toastLabel.removeFromSuperview()
     }
 }
 
 
 NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
 */
