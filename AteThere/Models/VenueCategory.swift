//
//  Category.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/11/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

struct VenueCategory {
    let categoryName: String
    
    init?(json: [[String: AnyObject]]) {
        guard let dictionary = json.first,
        let name = dictionary[JSONKeys.shortName.description] as? String else {
            return nil
        }
        
        self.categoryName = name
    }
}

extension VenueCategory {
    enum JSONKeys: String {
        case shortName
        
        var description: String {
            switch self {
            case .shortName: return "shortName"
            }
        }
    }
}
