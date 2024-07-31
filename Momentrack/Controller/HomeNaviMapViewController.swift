//
//  HomeNaviMapViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/31/24.
//

import UIKit

class HomeNaviMapViewController: UIViewController {
    
    private let homeNaviMapView = HomeNaviMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "내가 갔던 장소"
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(homeNaviMapView)
        
        homeNaviMapView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        //homeNaviMapView.delegate = self
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}
