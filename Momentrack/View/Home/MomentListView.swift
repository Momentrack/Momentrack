//
//  MomentListView.swift
//  Momentrack
//
//  Created by heyji on 2024/07/15.
//

import UIKit

final class MomentListView: UIView {

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
}

extension MomentListView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MomentCell.identifier, for: indexPath) as! MomentCell
        cell.configure(time: "", location: "", imageUrl: "", content: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "공유") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            if let cellImage = self.captureCell(at: indexPath) {
                let activityViewController = UIActivityViewController(activityItems: [cellImage], applicationActivities: nil)
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    rootViewController.present(activityViewController, animated: true, completion: nil)
                }
            }
            
            completionHandler(true)
        }
        
        shareAction.image = UIImage(systemName: "balloon")
        shareAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [shareAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, completionHaldler in
//            self.momentList.remove(at: indexPath.row)
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


extension MomentListView {
    func captureCell(at indexPath: IndexPath) -> UIImage? {
        guard let cell = momentTableView.cellForRow(at: indexPath) as? MomentCell else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(
            cell.bounds.size,
            false,
            UIScreen.main.scale
        )
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        cell.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndPDFContext()
       
        return image
    }
}
