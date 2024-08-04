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
        registerAuthStateDidChangeEvent()
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
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkLoginStatus),
            name: .AuthStateDidChange,
            object: nil)
    }
        
    @objc private func checkLoginStatus() {
        if Auth.auth().currentUser != nil {
            setHome()
        } else {
            routeToLogin()
        }
    }
    
    private func setHome() {
        let homeVC = HomeViewController()
        rootViewController = UINavigationController(rootViewController: homeVC)
    }

    private func routeToLogin() {
        rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
    
    func signInOrSignUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error as NSError? {
                // 로그인 실패 시 회원가입 시도
                if error.code == AuthErrorCode.userNotFound.rawValue {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            completion(false, "회원가입 실패: \(error.localizedDescription)")
                        } else {
                            self?.checkLoginStatus()
                            completion(true, "회원가입 및 로그인 성공")
                        }
                    }
                } else {
                    completion(false, "로그인 실패: \(error.localizedDescription)")
                }
            } else {
                self?.checkLoginStatus()
                completion(true, "로그인 성공")
            }
        }
    }
}

/*
final class AppController {
    static let shared = AppController()
    private init() {
        FirebaseApp.configure()
        registerAuthStateDidChangeEvent()
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
        
        
        if Auth.auth().currentUser == nil {
            routeToLogin()
            //setHome()
        }
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkLogin),
            name: .AuthStateDidChange,
            object: nil)
    }
        
    @objc private func checkLogin() {
        if let user = Auth.auth().currentUser { // <- Firebase Auth
            print("user = \(user)")
            setHome()
        } else {
            routeToLogin()
        }
    }
    
    private func setHome() {
        let homeVC = HomeViewController()
        rootViewController = UINavigationController(rootViewController: homeVC)
    }

    private func routeToLogin() {
        rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
    
}
*/
