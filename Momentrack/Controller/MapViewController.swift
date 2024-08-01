//
//  MapViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/25/24.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit

protocol MapViewControllerDelegate: AnyObject {
    func didSelectLocationWithCoordinate(_ address: String?, latitude: Double, longitude: Double)
    func dismissMapViewController()
}


final class MapViewController: UIViewController {
    var locationManager = CLLocationManager()
    weak var mapDelegate: MapViewControllerDelegate?
    
    var selectedLocationAddress: String?
    private var selectedLatitude: Double?
    private var selectedLongitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //requestLocationPermission()
    }
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var confirmButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        configuration.attributedTitle = AttributedString("확인", attributes: titleContainer)
        configuration.baseForegroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 16, bottom: 8, trailing: 16)
        let button = UIButton(configuration: configuration)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(downPopViewButton), for: .touchUpInside)
        return button
    }()

    @objc func downPopViewButton() {
        self.mapDelegate?.dismissMapViewController()
    }

    public func requestLocationPermission() {
       locationManager = CLLocationManager()
       locationManager.delegate = self
       locationManager.requestWhenInUseAuthorization()
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
       DispatchQueue.global(qos: .userInitiated).async {
           if CLLocationManager.locationServicesEnabled() {
               switch self.locationManager.authorizationStatus {
               case .authorizedAlways, .authorizedWhenInUse:
                   self.checkAccuracyAuthorization()
               case .notDetermined:
                   DispatchQueue.main.async {
                       self.locationManager.requestAlwaysAuthorization()
                   }
               case .denied, .restricted:
                   DispatchQueue.main.async {
                       self.showLocationServicesDisabledAlert()
                   }
                   break
               default:
                   break
               }
           } else {
               self.showLocationServicesDisabledAlert()
           }
       }
   }
    
    func checkAccuracyAuthorization() {
        if #available(iOS 14.0, *) {
            switch locationManager.accuracyAuthorization {
            case .fullAccuracy:
                self.locationManager.startUpdatingLocation()
            case .reducedAccuracy:
                DispatchQueue.main.async {
                    self.showReducedAccuracyAlert()
                }
            @unknown default:
                self.locationManager.startUpdatingLocation()
            }
        } else {

            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func showReducedAccuracyAlert() {
        let alert = UIAlertController(title: "위치 정확도 감소",
                                      message: "정확한 위치 사용이 꺼져 있습니다. 대략적인 위치로 계속하시겠습니까?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "계속", style: .default, handler: { _ in
            self.locationManager.startUpdatingLocation()
        }))

        alert.addAction(UIAlertAction(title: "설정 변경", style: .default, handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url) { success in
                    print(success)
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
   
   public func showLocationServicesDisabledAlert() {
       
       let alertController = UIAlertController(
           title: "위치 권한 비활성화",
           message: "위치 정보를 등록하기 위해 일시적인 위치 허용설정을 켜야합니다. 설정으로 이동하시겠습니까?",
           preferredStyle: .alert
       )
       
       let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
       let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
           guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
           if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url) { success in
                   print(success)
               }
           }
       }
       
       alertController.addAction(cancelAction)
       alertController.addAction(settingsAction)
       
       present(alertController, animated: true, completion: nil)
   }
    
    private func setupView() {
        view.addSubview(mapView)
        view.addSubview(confirmButton)
 
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }

    }
    
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            checkAccuracyAuthorization()
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.showLocationServicesDisabledAlert()
            }
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let placemark = placemarks?.first {
                var address = ""
                
                if #available(iOS 14.0, *) {
                    if self.locationManager.accuracyAuthorization == .fullAccuracy {
                        
//                        if let subThoroughfare = placemark.subThoroughfare {
//                            address += subThoroughfare + ", 📌"
//                        }
                        
//                        if let throughfare = placemark.thoroughfare {
//                            address += throughfare + " "
//                        }
                    }
                }
                
                if let country = placemark.country {
                    address += country + " "
                }
                
//                if let admistrativeArea = placemark.administrativeArea {
//                    address += admistrativeArea + ",🍃 "
//                }
                if let local = placemark.locality {
                    address += local + " "
                }
                
                if let sublocal = placemark.subLocality {
                    address += sublocal + " "
                }
                
                self.selectedLocationAddress = address
                self.selectedLatitude = location.coordinate.latitude
                self.selectedLongitude = location.coordinate.longitude
                
                DispatchQueue.main.async {
                    self.mapDelegate?.didSelectLocationWithCoordinate(address, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
            }
        }
        manager.stopUpdatingLocation()
    }
}

// MARK: - Preview Setting
#if DEBUG
import SwiftUI
struct MapViewPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        MapViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct MapViewController_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            MapViewPreview()
        }
    }
}
#endif
