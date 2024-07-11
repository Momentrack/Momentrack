//
//  LoginViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/11/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        self.view.addSubview(loginView)
    }
    

    func setTargetAction() {
        loginView.emailButton.addTarget(self, action: #selector(moveHomeVC), for: .touchUpInside)
    }
    
    @objc func moveHomeVC() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true)
    }
    
}
