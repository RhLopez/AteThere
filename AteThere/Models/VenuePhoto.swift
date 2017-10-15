//
//  VenuePhoto.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/13/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

enum ImageState {
    case downloaded
    case placeholder
}

struct VenuePhoto {
    var imageUrl: String?
    var image: UIImage?
    var imageState = ImageState.placeholder
    
    init?(json: [String: AnyObject]) {
        
        guard let prefix = json[JSONKeys.prefix.description] as? String,
            let suffix = json[JSONKeys.suffix.description] as? String else { return nil }
        
        self.imageUrl = "\(prefix)250x250\(suffix)"
        self.image = nil
    }
}

extension VenuePhoto {
    enum JSONKeys: String {
        case prefix
        case suffix
        
        var description: String {
            switch self {
            case .prefix: return "prefix"
            case .suffix: return "suffix"
            }
        }
    }
}
