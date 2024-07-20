//
//  PostingMomentView.swift
//  Momentrack
//
//  Created by Nat Kim on 7/20/24.
//

import UIKit
import SnapKit

class PostingMomentView: UIView {
    
    lazy var withFriendLabel: UILabel = {
        let label = UILabel()
        label.text = "함께한 사람 선택"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    lazy var currentLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 위치"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    lazy var photoLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 등록"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    lazy var uploadPhoto: UIImageView = {
        let photo = UIImageView()
        
        
        return photo
    }()
    
    lazy var writingLabel: UILabel = {
        let label = UILabel()
        label.text = "글 등록"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label

        return label
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("완료", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(withFriendLabel)
    }
    
}
