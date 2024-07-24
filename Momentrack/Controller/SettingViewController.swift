//
//  SettingViewController.swift
//  Momentrack
//
//  Created by heyji on 2024/07/22.
//

import UIKit

final class SettingViewController: UIViewController {
    
    private let settingView = SettingView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "설정"
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(settingView)
        
        settingView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        settingView.tableView.separatorStyle = .none
        settingView.reNicknameButton.addTarget(self, action: #selector(changeNicknameButtonTapped), for: .touchUpInside)
        
        settingView.delegate = self
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func changeNicknameButtonTapped(_ sender: UIButton) {
        let viewController = CustomAlertViewController(mainTitle: "닉네임 수정하기", textFieldPlaceholder: "닉네임", customAlertType: .doneAndCancel, alertHeight: 244)
        viewController.delegate = self
        viewController.nickNameTextField.becomeFirstResponder()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
    
}

extension SettingViewController: CustomAlertDelegate {
    func action() {
        
    }
    
    func exit() {
        
    }
}

extension SettingViewController: SettingDelegate {
    func action(indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let viewController = CustomAlertViewController(mainTitle: "친구 추가하기", textFieldPlaceholder: "이메일을 입력하세요.", customAlertType: .doneAndCancel, alertHeight: 244)
            viewController.delegate = self
            viewController.nickNameTextField.becomeFirstResponder()
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true)
        case 1:
            fatalError()
        case 2:
            fatalError()
        default:
            fatalError()
        }
    }
}
