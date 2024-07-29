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

        getUserInfo()
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func changeNicknameButtonTapped(_ sender: UIButton) {
        let viewController = CustomAlertViewController(mainTitle: "닉네임 수정하기", textFieldPlaceholder: self.settingView.getNickname(), customAlertType: .doneAndCancel, alertHeight: 244)
        viewController.delegate = self
        viewController.customTextField.becomeFirstResponder()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
    
    private func getUserInfo() {
        Network.shared.getUserInfo { user in
            self.settingView.configure(email: user.email, nickname: user.nickname)
        }
    }
}

extension SettingViewController: CustomAlertDelegate {
    func action(data: String) {
        Network.shared.updateNickname(nickname: data)
        getUserInfo()
    }
    
    func exit() {
        
    }
}

extension SettingViewController: SettingDelegate {
    func action(indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            fatalError()
        case 1:
            fatalError()
        default:
            fatalError()
        }
    }
}
