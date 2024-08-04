//
//  BaseViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 8/4/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func showAuthAlert(message: String) {
        let alert = UIAlertController(title: "가입정보", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func validateInputs(emailTextField: UITextField, passwordTextField: UITextField, passwordErrorLabel: UILabel, actionButton: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        let isEmailValid = User.isValidEmail(id: email)
        let isPasswordValid = User.isValidPassword(pwd: password)
        
        passwordErrorLabel.isHidden = isPasswordValid
        actionButton.isEnabled = isEmailValid && isPasswordValid
        }
        
        func setupTextFields(emailTextField: UITextField, passwordTextField: UITextField) {
            emailTextField.delegate = self
            passwordTextField.delegate = self
            
            emailTextField.tag = 0
            passwordTextField.tag = 1
            
            emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            
        }
    
}

extension BaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
