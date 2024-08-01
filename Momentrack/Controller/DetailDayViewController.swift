//
//  DetailDayViewController.swift
//  Momentrack
//
//  Created by heyji on 2024/07/25.
//

import UIKit

final class DetailDayViewController: UIViewController {
    
    private let detailDayView = MomentListView()
    var moment: AllOfMoment?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = moment?.date
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(detailDayView)
        
        detailDayView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        guard let moments = moment?.moment else { return }
        self.detailDayView.momentList = moments
        self.detailDayView.momentTableView.reloadData()
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
