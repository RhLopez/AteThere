//
//  Location.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/8/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

struct Location {
    let address: String
    let city: String
    let state: String
    let zipCode: String
    
    init?(json: [String: AnyObject]) {
        guard let address = json[JSONKeys.address.description] as? String,
            let city = json[JSONKeys.city.description] as? String,
            let state = json[JSONKeys.state.description] as? String,
            let zipCode = json[JSONKeys.zipCode.description] as? String else { return nil }
        
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
}

extension Location {
    enum JSONKeys {
        case address
        case city
        case state
        case zipCode
        
        var description: String {
            switch self {
            case .address: return "address"
            case .city: return "city"
            case .state: return "state"
            case .zipCode: return "postalCode"
            }
        }
    }
}
