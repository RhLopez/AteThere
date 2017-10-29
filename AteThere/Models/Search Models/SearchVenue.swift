//
//  Venue.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/4/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

class SearchVenue {
    let name: String
    let id: String
    let location: SearchLocation?
    let url: String?
    let telphone: SearchVenueTelephone?
    let category: SearchVenueCategory?
    var bestPhoto: SearchVenueBestPhoto? = nil
    var photos: [SearchVenuePhoto] = []
    
    init?(json: [String: AnyObject]) {        
        guard let name = json[JSONKeys.name.description] as? String,
            let id = json[JSONKeys.id.description] as? String else {
                return nil
        }
        
        self.name = name
        self.id = id
        
        if let contactDict = json[JSONKeys.contact.description] as? [String: AnyObject] {
            self.telphone = SearchVenueTelephone(json: contactDict)
        } else {
            self.telphone = nil
        }
        
        if let locationDict = json[JSONKeys.location.description] as? [String: AnyObject] {
            self.location = SearchLocation(json: locationDict)
        } else {
            self.location = nil
        }
        
        if let categoryDict = json[JSONKeys.categories.description] as? [[String: AnyObject]] {
            self.category = SearchVenueCategory(json: categoryDict)
        } else {
            self.category = nil
        }
        
        url = json[JSONKeys.url.description] as? String ?? nil
        
    }
    
    func updateWithPhotos(json: [String: AnyObject]) {
        if let bestPhotoDict = json[JSONKeys.bestPhoto.description] as? [String: AnyObject] {
            self.bestPhoto = SearchVenueBestPhoto(json: bestPhotoDict)
        } else {
            self.bestPhoto = nil
        }
    }
}

extension SearchVenue {
    enum JSONKeys: String {
        case name
        case id
        case contact
        case location
        case categories
        case bestPhoto
        case photos
        case groups
        case items
        case url
        
        var description: String {
            switch self {
            case .name: return "name"
            case .id: return "id"
            case .contact: return "contact"
            case .location: return "location"
            case .categories: return "categories"
            case .bestPhoto: return "bestPhoto"
            case .photos: return "photos"
            case .groups: return "groups"
            case .items: return "items"
            case .url: return "url"
            }
        }
    }
}
