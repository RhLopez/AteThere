//
//  VenuePhoto.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/13/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

enum ImageState: Equatable {
    case downloaded(IndexedImage)
    case placeholder
}

func ==(lhs: ImageState, rhs: ImageState) -> Bool {
    switch (lhs, rhs) {
    case (.placeholder, .placeholder):
        return true
    default:
        return false
    }
}

struct SearchVenuePhoto {
    var imageUrl: String?
    var indexedImage: IndexedImage?
    var imageState = ImageState.placeholder
    
    init?(json: [String: AnyObject]) {
        
        guard let prefix = json[JSONKeys.prefix.description] as? String,
            let suffix = json[JSONKeys.suffix.description] as? String else { return nil }
        
        self.imageUrl = "\(prefix)250x250\(suffix)"
        self.indexedImage = nil
    }
}

extension SearchVenuePhoto {
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
