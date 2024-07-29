//
//  HomeViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/11/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let friendListView = FriendListView()
    private let todayDateView = TodayDateView()
    private let momentListView = MomentListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupBlurEffect()
    }
    
    private func setupNavigationBar() {
        let titleConfig = CustomBarItemConfiguration(title: "MomenTrack", action: {})
        let titleItem = UIBarButtonItem.generate(with: titleConfig)
        navigationItem.leftBarButtonItem = titleItem
        
        let settingsConfig = CustomBarItemConfiguration(image: UIImage(systemName: "gearshape")) {
            let settingViewController = SettingViewController()
            settingViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(settingViewController, animated: true)
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
    
    // MARK: - floating Button(append travel log)
    
    private let floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "floating_90"), for: .normal)
        button.addTarget(self, action: #selector(touchUpBottomSheet), for: .touchUpInside)
        return button
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0
        return view
    }()
    
    func setupBlurEffect() {
        view.addSubview(blurView)
        view.bringSubviewToFront(floatingButton)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.bringSubviewToFront(floatingButton)
//        let blurEffect = UIBlurEffect(style: .prominent)
//        let blur2 = UIBlurEffect(style: .regular)
//        let vibrancyEffect = UIVibrancyEffect(blurEffect: blur2)
//        let visualEffectView = UIVisualEffectView(effect: blurEffect)
//        //let visualEffectView = UIVisualEffectView(effect: vibrancyEffect)
//        visualEffectView.frame = view.frame
//        blurView.addSubview(visualEffectView)
        
    }
    
    @objc func touchUpBottomSheet() {
        let vc = PostingMomentViewController()

        vc.isModalInPresentation = false
        
        if let sheet = vc.presentationController as? UISheetPresentationController {
            sheet.delegate = self
            sheet.detents = [
                .custom { context in
                    return context.maximumDetentValue * 0.90
                }
                //.medium()
            ]
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
     
        
        present(vc, animated: true)
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(friendListView)
        self.view.addSubview(todayDateView)
        self.view.addSubview(momentListView)
        self.view.addSubview(floatingButton)
        
        view.addSubview(blurView)
        view.bringSubviewToFront(floatingButton)
        
        friendListView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        todayDateView.snp.makeConstraints { make in
            make.top.equalTo(self.friendListView.snp.bottom).offset(15)
            make.left.equalToSuperview()
            make.height.equalTo(30)
        }
        momentListView.snp.makeConstraints { make in
            make.top.equalTo(self.todayDateView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }

        floatingButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        blurView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(view.snp.width)
            $0.top.equalToSuperview().inset(800)
        }
        
    }
}

extension HomeViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if sheetPresentationController.selectedDetentIdentifier == nil {
            print("detent identifier is nil")
            
        } else if sheetPresentationController.selectedDetentIdentifier == .medium {
            
            dismiss(animated: true)
        }
    }
}

// MARK: - Preview Setting

#if DEBUG
import SwiftUI
struct HomeViewPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
       HomeViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct HomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            HomeViewPreview()
        }
    }
}
#endif

