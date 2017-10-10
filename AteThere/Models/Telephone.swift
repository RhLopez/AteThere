//
//  Telephone.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/9/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

struct Telephone {
    let formattedPhone: String
    
    init?(json: [String: AnyObject]) {
        guard let phoneNumber = json[Keys.formattedPhone.description] as? String else {
            return nil
        }
        
        self.formattedPhone = phoneNumber
    }
}

extension Telephone {
    enum Keys {
        case formattedPhone
        
        var description: String {
            switch self {
            case .formattedPhone: return "formattedPhone"
            }
        }
    }
}
