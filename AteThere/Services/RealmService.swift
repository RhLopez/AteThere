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

class RealmService: VenueServicing {
    
    private var realm: Realm
    private var notificationToken: NotificationToken? = nil
    
    init(with realm: Realm) {
        self.realm = realm
    }
    
    convenience init() {
        let realm = try! Realm()
        self.init(with: realm)
    }
    
    func add(meal: Meal, forVenue searchVenue: SearchVenue) throws {
        var venue: Venue
        if let savedVenue = getVenue(named: searchVenue.name, withId: searchVenue.id) {
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
    
    func getVenues() -> [Venue] {
        let resultsVenue = realm.objects(Venue.self).sorted(byKeyPath: "name")
        let venues: [Venue] = resultsVenue.map { $0 }
        return venues
    }
    
    func getMeals(forVenue venue: Venue) -> [Meal] {
        if let savedVenue = realm.object(ofType: Venue.self, forPrimaryKey: venue.id) {
            let results = savedVenue.meals
            let meals: [Meal] = results.map { $0 }
            return meals
        }
        return []
    }
    
    func deleteVenue(id: String) {
        if let venue = realm.object(ofType: Venue.self, forPrimaryKey: id) {
            try! realm.write {
                realm.delete(venue.meals)
                realm.delete(venue)
            }
        }
    }
    
    func observe(changes: @escaping (VenueServicing, VenueChanges) -> Void) -> String {
        let results = realm.objects(Venue.self).sorted(byKeyPath: "name")
        
        notificationToken = results.observe({ [weak self] (realmChanges) in
            guard let strongSelf = self else { return }
            
            switch realmChanges {
            case .initial(_):
                changes(strongSelf, .initial)
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                changes(strongSelf, .update(deletions: deletions, insertions: insertions, modifications: modifications))
            case .error(_):
                changes(strongSelf, .error)
            }
        })
        return "token"
    }
    
    func stopObserving(token: String) {
        notificationToken?.invalidate()
        notificationToken = nil
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

// Mark: - Helper Methods
extension RealmService {
    private func getVenue(named venueName: String, withId id: String) -> Venue? {
        if let venue = realm.objects(Venue.self).filter("name = %@", venueName).first, venue.id == id {
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
