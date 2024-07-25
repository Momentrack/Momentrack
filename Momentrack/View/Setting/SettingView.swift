//
//  SettingView.swift
//  Momentrack
//
//  Created by heyji on 2024/07/22.
//

import UIKit

protocol SettingDelegate {
    func action(indexPath: IndexPath)
}

final class SettingView: UIView {
    
    private let settingList: [String] = ["친구 추가", "로그아웃", "회원탈퇴"]
    var delegate: SettingDelegate?
    
    private let profileView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        imageView.layer.cornerRadius = 60 / 2
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "연동된 이메일"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    private var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "00000000@gmail.com"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var emailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private let nicknameView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let nicknameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "0000000000"
        return label
    }()
    
    let reNicknameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TitleButtonCell.self, forCellReuseIdentifier: TitleButtonCell.identifier)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(email: String, nickname: String) {
        self.emailLabel.text = email
        self.nicknameLabel.text = nickname
    }
    
    func getNickname() -> String {
        return self.nicknameLabel.text ?? ""
    }
    
    private func setupView() {
        addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(emailStackView)
        addSubview(nicknameView)
        nicknameView.addSubview(nicknameTitleLabel)
        nicknameView.addSubview(nicknameLabel)
        nicknameView.addSubview(reNicknameButton)
        addSubview(tableView)
        
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(80)
        }
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.height.equalTo(60)
        }
        emailStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(profileImageView.snp.right).offset(21)
            make.right.equalToSuperview()
        }
        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(60)
        }
        nicknameTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(reNicknameButton.snp.left).inset(-6)
        }
        reNicknameButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(nicknameView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
}

extension SettingView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleButtonCell.identifier, for: indexPath) as! TitleButtonCell
        cell.configure(title: settingList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.action(indexPath: indexPath)
    }
}
