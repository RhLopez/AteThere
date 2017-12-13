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
    func deleteVenue(id: String)
    func add(meal: Meal, forVenue searchVenue: SearchVenue) throws
    func getMeals(forVenue venue: Venue) -> [Meal]
    func observe(changes: @escaping (VenueServicing, VenueChanges) -> Void) -> String
    func stopObserving(token: String)
}

enum VenueChanges {
    case initial
    case update(deletions: [Int], insertions: [Int], modifications: [Int])
    case error
}
