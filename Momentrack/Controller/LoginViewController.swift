//
//  LoginViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/11/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    override func loadView() {
        view = loginView
        loginView.emailTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setTargetAction()
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    let emailRegexPattern = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
    var emailValid = false
    
    fileprivate func isValid(text: String, regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
    
    fileprivate func checkEmail() {
        if isValid(text: loginView.emailTextField.text!, regex: emailRegexPattern) {
            emailValid = true
        } else {
            emailValid = false
        }
    }

    func setTargetAction() {
        loginView.authButton.addTarget(self, action: #selector(didTapAuthButton), for: .touchUpInside)
        loginView.loginButton.addTarget(self, action: #selector(didTappedLoginBtn), for: .touchUpInside)
    }
    
    @objc func didTapAuthButton() {
        guard let email = loginView.emailTextField.text else {
            showAlert(message: "이메일을 입력해주세요.")
            return
        }
        
        checkEmail()
            
            if emailValid {
                Network.shared.createNewUser(email: email) { [weak self] result in
                    DispatchQueue.main.async {
                        if result == "email sent" {
                            self?.showAlert(message: "받은 메일함을 확인하세요.")
                        } else {
                            self?.showAlert(message: "오류가 발생했습니다: \(result)")
                        }
                    }
                }
            } else {
                showAlert(message: "유효한 이메일 주소를 입력해주세요.")
            }
    }
    
    @objc func didTappedLoginBtn() {
        guard let email = loginView.emailTextField.text else { return }
        
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
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
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
