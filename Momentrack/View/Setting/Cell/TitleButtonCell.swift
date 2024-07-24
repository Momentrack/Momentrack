//
//  TitleButtonCell.swift
//  Momentrack
//
//  Created by heyji on 2024/07/22.
//

import UIKit

final class TitleButtonCell: UITableViewCell {
    
    static let identifier: String = "TitleButtonCell"
    
    private var titleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleButton.setTitle(title, for: .normal)
    }
    
    private func setupCell() {
        contentView.addSubview(titleButton)
        titleButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
    }
}
