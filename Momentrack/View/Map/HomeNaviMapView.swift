//
//  MapView.swift
//  Momentrack
//
//  Created by Nat Kim on 7/11/24.
//

import UIKit
import MapKit
import SnapKit

class HomeNaviMapView: UIView {
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        return mapView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        self.addSubview(mapView)

        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}



