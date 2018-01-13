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
    case unknownError
    case networkUnavailable
    case locationUnknown
    case unableToProcessRequest
    case unableToFindLocation
}

protocol LocationPermissionDelegate: class {
    func authorizationFailedWithStatus(_ error: LocationError)
}

protocol LocationManagerDelegate: class {
    func obtainedCoordinates(_ coordinate: CLLocationCoordinate2D)
    func failedWithError(_ error: LocationError)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    weak var locationPermissionDelegate: LocationPermissionDelegate?
    weak var delegate: LocationManagerDelegate?
    
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
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            locationPermissionDelegate?.authorizationFailedWithStatus(.deniedByUser)
        case .restricted:
            locationPermissionDelegate?.authorizationFailedWithStatus(.restrictedAccess)
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            delegate?.failedWithError(.unknownError)
            return
        }
        
        switch error.code {
        case .denied:
            delegate?.failedWithError(.deniedByUser)
        case .network:
            delegate?.failedWithError(.networkUnavailable)
        case .locationUnknown:
            delegate?.failedWithError(.locationUnknown)
        default:
            delegate?.failedWithError(.unableToProcessRequest)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            delegate?.failedWithError(.unableToFindLocation)
            return
        }
        
        let coordinate: CLLocationCoordinate2D = location.coordinate
        
        delegate?.obtainedCoordinates(coordinate)
    }
}
