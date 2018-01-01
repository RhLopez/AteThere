//
//  LocationManager.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 12/30/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case deniedByUser
    case restrictedAccess
}

protocol LocationPermissionDelegate: class {
    func authorizationSucceeded()
    func authorizationFailedWithStatus(_ error: LocationError)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    weak var delegate: LocationPermissionDelegate?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func checkForLocationServices() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func requestLocationAuthorization() throws {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        switch authorizationStatus {
        case .restricted:
            throw LocationError.restrictedAccess
        case .denied:
            throw LocationError.deniedByUser
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            delegate?.authorizationFailedWithStatus(.deniedByUser)
        case .restricted:
            delegate?.authorizationFailedWithStatus(.restrictedAccess)
        case .authorizedWhenInUse, .authorizedAlways:
            delegate?.authorizationSucceeded()
        default:
            return
        }
    }
}
