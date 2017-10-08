//
//  Venue.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/4/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

struct Venue {
    let name: String
    let id: String
    let address: String
    let city: String
    let state: String
    let zipCode: String
    
    init?(json: [String: AnyObject]) {        
        guard let name = json[Keys.name.description] as? String,
            let id = json[Keys.id.description] as? String,
            let locationDict = json[Keys.location.description] as? [String: AnyObject],
            let address = locationDict[Keys.address.description] as? String,
            let city = locationDict[Keys.city.description] as? String,
            let state = locationDict[Keys.state.description] as? String,
            let zipCode = locationDict[Keys.zipCode.description] as? String else {
                return nil
        }
        self.name = name
        self.id = id
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
}

extension Venue {
    enum Keys: String {
        case name
        case id
        case location
        case address
        case city
        case state
        case zipCode
        
        var description: String {
            switch self {
            case .name: return "name"
            case .id: return "id"
            case .location: return "location"
            case .address: return "address"
            case .city: return "city"
            case .state: return "state"
            case .zipCode: return "postalCode"
            }
        }
    }
}
