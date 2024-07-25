//
//  CalendarViewController.swift
//  Momentrack
//
//  Created by heyji on 2024/07/24.
//

import UIKit

final class CalendarViewController: UIViewController {
    
    private let calendarView = CalendarView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "달력"
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(calendarView)
        
        calendarView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        calendarView.delegate = self
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
