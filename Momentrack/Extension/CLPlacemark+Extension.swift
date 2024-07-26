//
//  MapAddress+Extension.swift
//  Momentrack
//
//  Created by Nat Kim on 7/25/24.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    var formattedAddress: String? {
        if let name = name, let locality = subLocality, let administrativeArea = administrativeArea {
            return "name:\(name), localty:\(locality), admi:\(administrativeArea)"
        }
        return nil
    }
}
