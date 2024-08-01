//
//  CalendarViewController.swift
//  Momentrack
//
//  Created by heyji on 2024/07/24.
//

import UIKit

final class CalendarViewController: UIViewController {
    
    private let calendarView = CalendarView()
    private let historyView = HistoryView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
        
        Network.shared.getMomentList { momentList in
            self.historyView.allOfMoment = momentList
            self.historyView.collectionView.reloadData()
        }
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "추억 보관소"
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
//        self.view.addSubview(calendarView)
        self.view.addSubview(historyView)
        
//        calendarView.snp.makeConstraints { make in
//            make.edges.equalTo(self.view.safeAreaLayoutGuide)
//        }
//        
//        calendarView.delegate = self
        
        historyView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        historyView.delegate = self
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension CalendarViewController: CalendarViewDelegate {
    func showDetailView(indexPath: IndexPath) {
        let detailDayViewController = DetailDayViewController()
        self.navigationController?.pushViewController(detailDayViewController, animated: true)
    }
}
