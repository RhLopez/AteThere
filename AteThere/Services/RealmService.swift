//
//  RealmService.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/28/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmServiceError: Error {
    case ErrorSaving
}

class RealmService {
    
    private var realm: Realm
    
    init(with realm: Realm) {
        self.realm = realm
    }
    
    convenience init() {
        let realm = try! Realm()
        self.init(with: realm)
    }
    
    func add(meal: Meal, forVenue searchVenue: SearchVenue) throws {
        var venue = Venue()
        if let savedVenue = getVenue(named: venue.name, withId: venue.id) {
            venue = savedVenue
        } else {
            venue = Venue(withSearchVenue: searchVenue)
            saveLocation(forVenue: venue, location: searchVenue.location!)
        }
        
        do {
            try realm.write {
                venue.meals.append(meal)
                realm.add(venue, update: true)
            }
        } catch {
            throw RealmServiceError.ErrorSaving
        }
    }
}

// Mark: - Helper Methods
extension RealmService {
    func getVenue(named venueName: String, withId id: String) -> Venue? {
        if let venue = realm.objects(Venue.self).filter("name = %@", venueName).first, venue.id != id {
            return venue
        } else {
            return nil
        }
    }
    
    func saveLocation(forVenue venue: Venue, location: SearchLocation) {
        let location = Location(withSearchLocation: location)
        do {
            try realm.write {
                venue.locations.append(location)
            }
        } catch {
            print(error)
        }
    }
}
