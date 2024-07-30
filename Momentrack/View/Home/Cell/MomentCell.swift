//
//  MomentCell.swift
//  Momentrack
//
//  Created by heyji on 2024/07/15.
//

import UIKit
import MapKit

final class MomentCell: UITableViewCell {
    
    static let identifier: String = "MomentCell"
    
    let locationManger = CLLocationManager()
    
    private var friendList: [String] = []
    
    private let cellView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let timeView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let locationView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let locationLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        button.isHidden = true
        return button
    }()
    
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationLabel, menuButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // NOTE: 이미지가 없을 시에는 위치 지도 보여주기
    private var mapView: MKMapView = {
        let view = MKMapView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let contentsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let friendListView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        return collectionView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationView, locationLineView, photoImageView, mapView, contentsView, friendListView])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeView, contentStackView])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var dotLine: UIView = {
        let dotLine = UIView(frame: CGRect(x: .zero , y: .zero, width: contentsView.bounds.width, height: 30))
        
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.systemGray.cgColor
        layer.lineDashPattern = [4, 4]
        layer.lineWidth = 4
        
        let path = UIBezierPath()
        let point1 = CGPoint(x: dotLine.bounds.midX, y: dotLine.bounds.minY)
        let point2 = CGPoint(x: dotLine.bounds.midX, y: dotLine.bounds.maxY)
        
        path.move(to: point1)
        path.addLine(to: point2)
        
        layer.path = path.cgPath
        dotLine.layer.addSublayer(layer)
        
        return dotLine
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(time: String, location: String, friendList: [String], latitude: Double, longitude: Double ,imageUrl: String? = nil, content: String? = nil) {
        timeLabel.text = time
        locationLabel.text = location
        self.friendList = friendList
        if imageUrl == "" {
            photoImageView.isHidden = true
        } else {
            guard let imageUrl else { return }
            photoImageView.setImageURL(imageUrl)
            mapView.isHidden = true
        }
        if content == "" {
            contentLabel.isHidden = true
        } else {
            contentLabel.text = content
        }
        setAnnotation(latitudeValue: latitude, longitudeValue: longitude, delta: 0.0005, title: "", subtitle: "")
    }
    
    private func setupCell() {
        contentView.addSubview(cellView)
        contentView.addSubview(dotLine)
        cellView.addSubview(mainStackView)
        timeView.addSubview(timeLabel)
        locationView.addSubview(locationStackView)
        contentsView.addSubview(contentLabel)
        friendListView.addSubview(collectionView)
        
        cellView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        timeView.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(6)
        }
        locationView.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        locationLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        locationStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(6)
        }
        photoImageView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        mapView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
        friendListView.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dotLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cellView.snp.bottom)
            make.height.equalTo(30)
            make.bottom.equalToSuperview()
        }
        
        collectionView.register(MomentFriendCell.self, forCellWithReuseIdentifier: MomentFriendCell.identifier)
        collectionView.alwaysBounceVertical = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft

        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(15), heightDimension: .absolute(15))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(15), heightDimension: .absolute(15))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension MomentCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MomentFriendCell.identifier, for: indexPath) as! MomentFriendCell
        cell.configure(nickname: String(friendList[indexPath.item].first!))
        
        return cell
    }
}

extension MomentCell: CLLocationManagerDelegate {
    
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        mapView.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String, subtitle strSubtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        mapView.addAnnotation(annotation)
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let pLocation = locations.last
//        goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.001)
//        CLGeocoder().reverseGeocodeLocation(pLocation!) { placemarks, error in
//            let pm = placemarks!.first
//            let country = pm!.country
//            var address: String = country!
//            if pm!.locality != nil {
//                address += ""
//                address += pm!.locality!
//            }
//            if pm!.thoroughfare != nil {
//                address += ""
//                address += pm!.thoroughfare!
//            }
//        }
//        locationManger.stopUpdatingLocation()
//    }
    
}
