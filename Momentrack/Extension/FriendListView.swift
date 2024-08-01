//
//  FriendListView.swift
//  Momentrack
//
//  Created by heyji on 2024/07/15.
//

import UIKit

protocol AddFriendDelegate {
    func action(indexPath: IndexPath)
}

final class FriendListView: UIView {
    
    lazy var friendList: [String] = []
    var withAddFriendCell: Bool = true
    var delegate: AddFriendDelegate?
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        return collectionView
    }()
    
    init(frame: CGRect, value: Bool) {
        super.init(frame: frame)
        self.withAddFriendCell = value
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        collectionView.register(FriendCell.self, forCellWithReuseIdentifier: FriendCell.identifier)
        collectionView.register(AddFriendCell.self, forCellWithReuseIdentifier: AddFriendCell.identifier)
        collectionView.alwaysBounceVertical = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(45), heightDimension: .absolute(45))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(45), heightDimension: .absolute(45))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension FriendListView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if withAddFriendCell {
            return friendList.count + 1
        } else {
            return friendList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if withAddFriendCell {
            if friendList.count == 0 || indexPath.item == friendList.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddFriendCell.identifier, for: indexPath) as! AddFriendCell
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCell.identifier, for: indexPath) as! FriendCell
                cell.configure(nickname: String(friendList[indexPath.item].first!))
                
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCell.identifier, for: indexPath) as! FriendCell
            cell.configure(nickname: String(friendList[indexPath.item].first!))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if friendList.count == 0 || indexPath.item == friendList.count {
            delegate?.action(indexPath: indexPath)
        }
    }
}
