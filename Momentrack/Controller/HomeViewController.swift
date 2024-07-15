//
//  HomeViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/11/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
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
    }
}
