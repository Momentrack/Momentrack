//
//  AppController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/12/24.
//
import UIKit
import FirebaseAuth
import FirebaseCore

final class AppController {
    static let shared = AppController()
    private init() {
        FirebaseApp.configure()
        //registerAuthStateDidChangeEvent()
    }
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    func show(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()

        checkLoginStatus()

        if Auth.auth().currentUser == nil {
            routeToLogin()
        }

    }
    
    private func registerSignUpRequestedEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSignUpRequest), name: .SignUpRequested, object: nil)
    }
    
    @objc private func handleSignUpRequest() {
        routeToSignUp()
    }
    
    @objc private func checkLoginStatus() {
        if Auth.auth().currentUser != nil {
            setHome()
        } else {
            routeToLogin()
        }
    }
    
    func setHome() {
        let homeVC = HomeViewController()
        rootViewController = UINavigationController(rootViewController: homeVC)
    }

    func routeToSignUp() {
        let signUpVC = SignUpViewController()
        rootViewController = UINavigationController(rootViewController: signUpVC)
    }
    
    func routeToLogin() {
        rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
   
}

extension Notification.Name {
    static let SignUpRequested = Notification.Name("SignUpRequested")
}
