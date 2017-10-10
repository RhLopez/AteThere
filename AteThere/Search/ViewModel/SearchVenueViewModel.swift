//
//  SearchVenueViewModel.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/8/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

struct SearchVenueViewModel {
    let name: String
    let id: String
    let address: String
    let phoneNumber: String
    let url: String
    
    init(withVenue venue: Venue) {
        self.name = venue.name
        self.id = venue.id
        
        if let location = venue.location {
            self.address = "\(location.address) \(location.city), \(location.state) \(location.zipCode)"
        } else {
            self.address = "Address not available"
        }
        
        self.phoneNumber = venue.telphone?.formattedPhone ?? "Telephone not available"
        
        self.url = venue.url ?? "Website not available"
    }
}
