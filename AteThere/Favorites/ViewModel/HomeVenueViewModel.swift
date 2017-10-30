//
//  HomeVenueViewModel.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/29/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

struct HomeVenueViewModel {
    
    let venue: Venue
    
    init(withVenue venue: Venue) {
        self.venue = venue
    }
    
    var name: String {
        return venue.name
    }
    
    var photoPath: String? {
        return venue.meals.first?.photoPath
    }
    
    var category: String {
        return venue.cateogry ?? ""
    }
}
