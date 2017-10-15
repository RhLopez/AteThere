//
//  VenuePhoto.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/12/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

struct VenueBestPhoto {
    var image: UIImage?
    let imageUrl: String
    
    init?(json: [String: AnyObject]) {
        guard let prefix = json[JSONKeys.prefix.description] as? String,
            let suffix = json[JSONKeys.suffix.description] as? String else { return nil }
        
        self.imageUrl = "\(prefix)700x700\(suffix)"
        self.image = nil
    }
}

extension VenueBestPhoto {
    enum JSONKeys: String {
        case prefix
        case suffix
        
        var description: String {
            switch self {
            case .prefix: return "prefix"
            case.suffix: return "suffix"
            }
        }
    }
}
