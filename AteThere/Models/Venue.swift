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
    let location: Location?
    let url: String?
    let telphone: Telephone?
    
    init?(json: [String: AnyObject]) {        
        guard let name = json[JSONKeys.name.description] as? String,
            let id = json[JSONKeys.id.description] as? String else {
                return nil
        }
        
        self.name = name
        self.id = id
        
        if let contactDict = json[JSONKeys.contact.description] as? [String: AnyObject] {
            self.telphone = Telephone(json: contactDict)
        } else {
            self.telphone = nil
        }
        
        if let locationDict = json[JSONKeys.location.description] as? [String: AnyObject] {
            self.location = Location(json: locationDict)
        } else {
            self.location = nil
        }
        
        url = json[JSONKeys.url.description] as? String ?? nil
        
    }
}

extension Venue {
    enum JSONKeys: String {
        case name
        case id
        case contact
        case location
        case url
        
        var description: String {
            switch self {
            case .name: return "name"
            case .id: return "id"
            case .contact: return "contact"
            case .location: return "location"
            case .url: return "url"
            }
        }
    }
}
