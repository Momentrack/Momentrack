//
//  MomentListView.swift
//  Momentrack
//
//  Created by heyji on 2024/07/15.
//

import UIKit

final class MomentListView: UIView {
    
    lazy var momentList: [Moment] = []

    lazy var momentTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MomentCell.self, forCellReuseIdentifier: MomentCell.identifier)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(momentTableView)
        momentTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func showShareActionSheet(for indexPath: IndexPath) {
        guard let vc = self.findVC(),
              let cell = momentTableView.cellForRow(at: indexPath) as? MomentCell else {
            return
        }
                
        let actionSheet = UIAlertController(title: "공유 옵션", message: nil, preferredStyle: .actionSheet)
        
        let shareLocationAction = UIAlertAction(title: "위치 정보 공유", style: .default) { [weak self] _ in
            self?.shareLocation(for: cell, from: vc)
        }
        
        let shareCellImageAction = UIAlertAction(title: "게시물 이미지공유", style: .default) { [weak self] _ in
            self?.shareCellImage(for: cell, from: vc)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionSheet.addAction(shareLocationAction)
        actionSheet.addAction(shareCellImageAction)
        actionSheet.addAction(cancelAction)
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    private func shareLocation(
        for cell: MomentCell,
        from viewController: UIViewController
    ) {
        SharingManager.shared.shareLocationByCoordinates(
            latitude: cell.latitude,
            longitude: cell.longitude,
            locationName: cell.locationLabel.text ?? "Unknown Location",
            from: viewController
        )
        
    }
    
    private func shareCellImage(
        for cell: MomentCell,
        from viewController: UIViewController
    ) {
        if let cellImage = cell.convertToImage() {
            SharingManager.shared.shareImage(cellImage, from: viewController)
        }
    }
}

extension MomentListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return momentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MomentCell.identifier, for: indexPath) as! MomentCell
        let moment = momentList[indexPath.row]
        
        cell.configure(time: moment.time, location: moment.location, friendList: moment.sharedFriends, latitude: moment.latitude, longitude: moment.longitude, imageUrl: moment.photoUrl, content: moment.memo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "공유") { [weak self] (action, view, completionHandler) in
            self?.showShareActionSheet(for: indexPath)
            completionHandler(true)
        }
        
        shareAction.image = UIImage(systemName: "balloon")
        shareAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [shareAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, completionHaldler in
            Network.shared.deleteMomentData(momentId: self.momentList[indexPath.row].id)
            self.momentList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHaldler(true)
        }
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17.0, weight: .bold, scale: .large)
        deleteAction.image = UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.systemRed)
        deleteAction.backgroundColor = .systemBackground
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
