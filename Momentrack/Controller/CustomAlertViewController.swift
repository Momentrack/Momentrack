//
//  CustomAlertViewController.swift
//  Momentrack
//
//  Created by heyji on 2024/07/22.
//

import UIKit

protocol CustomAlertDelegate {
    func action(data: String)
    func exit()
}

enum CustomAlertType {
    case onlyDone
    case doneAndCancel
}

final class CustomAlertViewController: UIViewController {
    
    private lazy var backgroudView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        view.backgroundColor = .black.withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = mainTitle
        label.textAlignment = .center
        return label
    }()
    
    lazy var customTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = textFieldPlaceholder
        textField.borderStyle = .line
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.addPadding(width: 16)
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 48 / 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 48 / 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 24
        return stackView
    }()
    
    private var mainTitle: String
    private var textFieldPlaceholder: String
    private var customAlertType: CustomAlertType
    private var height: Int
    
    var delegate: CustomAlertDelegate?
    
    init(mainTitle: String, textFieldPlaceholder: String, customAlertType: CustomAlertType, alertHeight: Int) {
        self.mainTitle = mainTitle
        self.textFieldPlaceholder = textFieldPlaceholder
        self.customAlertType = customAlertType
        self.height = alertHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        setCustomAlertView()
        
        switch customAlertType {
        case .onlyDone:
            cancelButton.isHidden = false
            doneButton.isHidden = true
        case .doneAndCancel:
            cancelButton.isHidden = false
            doneButton.isHidden = false
        }
    }
    
    private func setCustomAlertView() {
        self.view.addSubview(backgroudView)
        backgroudView.addSubview(mainView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(customTextField)
        mainView.addSubview(buttonStackView)
        
        backgroudView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(self.height)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(44)
            make.centerX.equalToSuperview()
        }
        customTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(48)
        }
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.exit()
        }
    }
    
    @objc func actionButtonTapped() {
        self.dismiss(animated: true) {
            let data = self.customTextField.text!
            self.delegate?.action(data: data)
        }
    }
}
