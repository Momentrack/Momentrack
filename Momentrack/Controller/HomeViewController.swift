//
//  HomeViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/11/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let friendListView = FriendListView()
    private var todayDate: String = "2024년 7월 8일 월요일" // Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        let titleConfig = CustomBarItemConfiguration(title: "MomenTrack", action: {})
        let titleItem = UIBarButtonItem.generate(with: titleConfig)
        navigationItem.leftBarButtonItem = titleItem
        
        let settingsConfig = CustomBarItemConfiguration(image: UIImage(systemName: "gearshape")) {
//            let settingViewController = SettingViewController()
//            settingViewController.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(settingViewController, animated: true)
        }
        let settingsItem = UIBarButtonItem.generate(with: settingsConfig, width: 30)
        
        let calendarConfig = CustomBarItemConfiguration(image: UIImage(systemName: "calendar")) {
            // TODO: calendarViewController
        }
        let calendarItem = UIBarButtonItem.generate(with: calendarConfig, width: 30)
        
        let mapConfig = CustomBarItemConfiguration(image: UIImage(systemName: "map")) {
            // TODO: mapViewController
        }
        let mapItem = UIBarButtonItem.generate(with: mapConfig, width: 30)
        
        navigationItem.rightBarButtonItems = [settingsItem, calendarItem, mapItem]
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(friendListView)
        
        friendListView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}
