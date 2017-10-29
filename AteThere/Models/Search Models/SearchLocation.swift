//
//  Location.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/8/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

struct SearchLocation {
    let address: String
    let city: String
    let state: String
    let zipCode: String
    let latitude: Double
    let longitude: Double
    
    init?(json: [String: AnyObject]) {
        guard let address = json[JSONKeys.address.description] as? String,
            let city = json[JSONKeys.city.description] as? String,
            let state = json[JSONKeys.state.description] as? String,
            let zipCode = json[JSONKeys.zipCode.description] as? String,
            let latitude = json[JSONKeys.latitude.description] as? Double,
            let longitude = json[JSONKeys.longitude.description] as? Double else { return nil }
        
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension SearchLocation {
    enum JSONKeys {
        case address
        case city
        case state
        case zipCode
        case latitude
        case longitude
        
        var description: String {
            switch self {
            case .address: return "address"
            case .city: return "city"
            case .state: return "state"
            case .zipCode: return "postalCode"
            case .latitude: return "lat"
            case .longitude: return "lng"
            }
        }
    }
}
