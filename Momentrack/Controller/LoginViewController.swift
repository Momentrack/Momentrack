//
//  LoginViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/11/24.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    override func loadView() {
        view = loginView
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
        guard let email = loginView.emailTextField.text else { return }
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://momentrack-8ab67.firebaseapp.com/?email=\(email)")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(
            toEmail: email,
            actionCodeSettings: actionCodeSettings) { error in
                if let error = error {
                    print("email not sent \(error.localizedDescription)")
                } else {
                    print("email sent")
                }
            }
    }
    @objc func didTappedLoginBtn() {
        guard let email = loginView.emailTextField.text,
              let link = UserDefaults.standard.string(forKey: "Link") else { return }
        Auth.auth().signIn(withEmail: email, link: link) { Result, error in
            if let error = error {
                print("✉️ email auth error \"\(error.localizedDescription)\"")
                return
            }
            //let homeVC = HomeViewController()
            //self?.navigationController?.pushViewController(homeVC, animated: true)
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
