//
//  HomeNaviMapViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/31/24.
//

import UIKit
import MapKit

class HomeNaviMapViewController: UIViewController {
    
    private let homeNaviMapView = HomeNaviMapView()
    private var moments: [AllOfMoment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        fetchMoments()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "내가 갔던 장소"
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(homeNaviMapView)
        
        homeNaviMapView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        homeNaviMapView.mapView.delegate = self
    }
    
    private func fetchMoments() {
        Network.shared.getMomentList { [weak self] moments in
            self?.moments = moments
            self?.addPinsToMap()
        }
    }
    
    private func addPinsToMap() {
        var annotations: [MKPointAnnotation] = []
        var minLat = Double.greatestFiniteMagnitude
        var maxLat = -Double.greatestFiniteMagnitude
        var minLon = Double.greatestFiniteMagnitude
        var maxLon = -Double.greatestFiniteMagnitude
        
        for allOfMoment in moments {
            for moment in allOfMoment.moment {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(
                    latitude: moment.latitude,
                    longitude: moment.longitude
                )
                annotation.title = moment.location
                homeNaviMapView.mapView.addAnnotation(annotation)
                
                minLat = min(minLat, moment.latitude)
                maxLat = max(maxLat, moment.latitude)
                minLon = min(minLon, moment.longitude)
                maxLon = max(maxLon, moment.longitude)
            }
        }
        
        if !annotations.isEmpty {
            let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
            let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.1, longitudeDelta: (maxLon - minLon) * 1.1)
            let region = MKCoordinateRegion(center: center, span: span)
            homeNaviMapView.mapView.setRegion(region, animated: true)
        }
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension HomeNaviMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "MomentPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let pinImage = UIImage(named: "pin_marker2") {
            let size = CGSize(width: 24, height: 32) // 원하는 크기로 조절
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            pinImage.draw(in: CGRect(origin: .zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView?.image = resizedImage
        }
        
        
        annotationView?.centerOffset = CGPoint(x: 0, y: -16)
        //print(UIImage(named: "pin_marker2") != nil)
        return annotationView
    }
}
