//
//  Venue.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/4/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

struct Venue: Decodable {
    let name: String
    let id: String
    
    init?(json: [String: AnyObject]) {        
        guard let name = json["name"] as? String,
            let id = json["id"] as? String else {
                return nil
        }
        self.name = name
        self.id = id
    }
}
