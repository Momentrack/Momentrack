//
//  HomeViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/11/24.
//

import UIKit
import CoreLocation

final class HomeViewController: UIViewController {
    
    private let friendListView = FriendListView(frame: .zero, value: true)
    private let todayDateView = TodayDateView()
    private let momentListView = MomentListView()
    
    private let refreshControl = UIRefreshControl()
    private let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupUserLocation()
        setupBlurEffect()
        getUserInfo()
        getMomentList()

        NotificationCenter.default.addObserver(self, selector: #selector(momentSaved), name: .momentSaved, object: nil)
    }

    private func setupNavigationBar() {
        let titleConfig = CustomBarItemConfiguration(image: UIImage(named: "homeLogo"),action: {})
        let titleItem = UIBarButtonItem.generate(with: titleConfig)
        navigationItem.leftBarButtonItem = titleItem
        
        let settingsConfig = CustomBarItemConfiguration(image: UIImage(systemName: "gearshape")) {
            let settingViewController = SettingViewController()
            settingViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(settingViewController, animated: true)
        }
        let settingsItem = UIBarButtonItem.generate(with: settingsConfig, width: 30)
        
        let calendarConfig = CustomBarItemConfiguration(image: UIImage(systemName: "calendar")) {
            let calendarViewController = CalendarViewController()
            self.navigationController?.pushViewController(calendarViewController, animated: false)
        }
        let calendarItem = UIBarButtonItem.generate(with: calendarConfig, width: 30)
        
        let mapConfig = CustomBarItemConfiguration(image: UIImage(systemName: "map")) {
            // TODO: mapViewController
            let homeNaviMapViewController = HomeNaviMapViewController()
            self.navigationController?.pushViewController(homeNaviMapViewController, animated: false)
        }
        let mapItem = UIBarButtonItem.generate(with: mapConfig, width: 30)
        
        navigationItem.rightBarButtonItems = [settingsItem, calendarItem, mapItem]
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    // MARK: - floating Button(append travel log)
    
    private lazy var floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "floatingButton"), for: .normal)
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
        
    }
    
    @objc func momentSaved() {
        getMomentList()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        friendListView.delegate = self
        momentListView.momentTableView.separatorStyle = .none
        
        refreshControl.addTarget(self, action: #selector(refreshWork), for: .valueChanged)
        momentListView.momentTableView.addSubview(refreshControl)
    }
    
    @objc func refreshWork() {
        refreshControl.beginRefreshing()
        self.getMomentList()
        refreshControl.endRefreshing()
    }
    
    private func setupUserLocation() {
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
    }
    
    private func getUserInfo() {
        Network.shared.getUserInfo { user in
            if user.friends.contains(user.email) {
                let friends = user.friends
                self.friendListView.friendList = friends.filter { $0 != user.email }
            }
            self.friendListView.collectionView.reloadData()
        }
    }
    
    private func getMomentList() {
        Network.shared.getMoments { moments in
            self.momentListView.momentList = moments
            self.momentListView.momentTableView.reloadData()
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

extension HomeViewController: AddFriendDelegate {
    func action(indexPath: IndexPath) {
        let viewController = CustomAlertViewController(mainTitle: "친구 추가하기", subTitle: "앱을 사용하는 친구만 추가할 수 있습니다.", textFieldPlaceholder: "이메일을 입력하세요.", customAlertType: .doneAndCancel, alertHeight: 244)
        viewController.delegate = self
        viewController.customTextField.becomeFirstResponder()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
}

extension HomeViewController: CustomAlertDelegate {
    func action(data: String) {
        // NOTE: email로 존재하는 사용자인지 확인
        Network.shared.getUsersInfo { snapshot in
            var count = snapshot.values.count
            for i in snapshot.values {
                count -= 1
                guard let userInfo = i as? [String: String] else { return }
                if userInfo["email"] == data {
                    Network.shared.getUserInfo { user in
                        // NOTE: 존재하는 사용자라면 친구 리스트에 등록되어 있는지 확인
                        if user.friends.contains(data) {
                            // NOTE: 등록되어 있으면 '등록한 친구입니다.' 알럿
                        } else {
                            // 등록되어 있지 않으면 친구 등록하기
                            Network.shared.addFriend(email: data) { result in
                                switch result {
                                case .success(_):
                                    self.getUserInfo()
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                    break
                }
                // '존재하지 않는 사용자입니다.' 알럿
                if count == 0 {
                    print("친구 노")
                }
            }
        }
    }
    
    func exit() {
        
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

