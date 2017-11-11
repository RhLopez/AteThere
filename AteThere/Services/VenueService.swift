//
//  VenueService.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/29/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

protocol VenueServicing {
    func getVenues() -> [Venue]
    func add(meal: Meal, forVenue searchVenue: SearchVenue) throws
    func getMeals(forVenue venue: Venue) -> [Meal]
}
