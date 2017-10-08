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
    
    init(withVenue venue: Venue) {
        self.name = venue.name
        self.id = venue.id
        self.address = "\(venue.address), \(venue.city), \(venue.state) \(venue.zipCode)"
    }
}
