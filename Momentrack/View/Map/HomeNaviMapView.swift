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
    
    let map = MKMapView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func configure() {
        
    }
    
    func makeConstraints() {
        self.addSubview(map)
        map.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
}



