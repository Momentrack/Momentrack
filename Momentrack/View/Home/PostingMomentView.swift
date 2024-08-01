//
//  PostingMomentView.swift
//  Momentrack
//
//  Created by Nat Kim on 7/20/24.
//

import UIKit
import SnapKit

class PostingMomentView: UIView {
    weak var textViewDelegate: UITextViewDelegate?
    
    let withFriends = FriendListView(frame: .zero, value: false)
    
    lazy var withFriendLabel: UILabel = {
        let label = UILabel()
        label.text = "함께한 사람 선택"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    lazy var currentLocationStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentLocationLabel, currentLocationBtn])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    

    lazy var currentLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 위치"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    lazy var currentLocationBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        //label.text = "테스트 주소입니다."
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.blue
        return label
    }()
    
    lazy var photoLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 등록"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    lazy var uploadPhoto: UIImageView = {
        let photo = UIImageView()
        photo.backgroundColor = .systemGray5
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        return photo
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
        
        button.tintColor = .black
        return button
    }()
    
    lazy var writingLabel: UILabel = {
        let label = UILabel()
        label.text = "글 등록"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label

        return label
    }()
    
    lazy var momentTextView: MomentTextView = {
        let textView = MomentTextView()
        textView.delegate = textViewDelegate
        return textView
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitle("완료", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(currentLocationStack)
        //self.addSubview(shareLocationBtn)
        self.addSubview(addressLabel)
        self.addSubview(withFriendLabel)
        self.addSubview(withFriends)
        self.addSubview(photoLabel)
        self.addSubview(uploadPhoto)
        uploadPhoto.addSubview(cameraButton)
        
        self.addSubview(writingLabel)
        self.addSubview(momentTextView)
        momentTextView.placeholderText = "당신의 여정을 기록해보세요."
        
        self.addSubview(saveButton)
        
        currentLocationStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(16)
        }

        addressLabel.snp.makeConstraints {
            $0.top.equalTo(currentLocationStack.snp.top).offset(32)
            $0.left.equalTo(currentLocationLabel.snp.left)
        }
        
        withFriendLabel.snp.makeConstraints {
            $0.top.equalTo(currentLocationStack.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(16)
        }
        
        withFriends.snp.makeConstraints {
            $0.top.equalTo(withFriendLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        photoLabel.snp.makeConstraints {
            $0.top.equalTo(withFriends.snp.bottom).offset(30)
            $0.left.equalTo(withFriendLabel.snp.left)
        }
        
        uploadPhoto.snp.makeConstraints {
            $0.top.equalTo(photoLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(160)
        }
        
        cameraButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        writingLabel.snp.makeConstraints {
            $0.left.equalTo(photoLabel)
            $0.top.equalTo(uploadPhoto.snp.bottom).offset(19)
        }
        
        momentTextView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.top.equalTo(writingLabel.snp.bottom).offset(8)
            //$0.bottom.equalTo(saveButton.snp.top).offset(12)
            $0.height.greaterThanOrEqualTo(100)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
    }
}

//MARK: - Preview Setting
#if DEBUG
import SwiftUI

struct SwiftUIPostingMomentView: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> some UIView {
        return PostingMomentView()
    }
}

struct PostingMomentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIPostingMomentView()
            .previewLayout(.sizeThatFits)
    }
}
#endif

