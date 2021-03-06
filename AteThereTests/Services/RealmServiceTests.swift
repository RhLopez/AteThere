//
//  RealmServiceTests.swift
//  AteThereTests
//
//  Created by Ramiro H Lopez on 10/29/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import XCTest
@testable import AteThere
import RealmSwift

class RealmServiceTests: XCTestCase {
    
    func test_getVenues_returnsSavedVenues() {
        let venues = [venue("1", name: "First"), venue("2", name: "Second"), venue("3", name: "Third")]
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        do {
            try realm.write {
                realm.add(venues)
            }
        } catch {
            print(error)
        }
        let sut = RealmService(with: realm)
        let savedVenues = sut.getVenues()
        XCTAssertEqual(savedVenues.count, 3)
        
        XCTAssertTrue(savedVenues.contains(venues[0]))
        XCTAssertTrue(savedVenues.contains(venues[1]))
        XCTAssertTrue(savedVenues.contains(venues[2]))
        
        XCTAssertFalse(savedVenues.contains(venue("4", name: "Fourth")))
    }
    
    func test_getVenues_returnsSortedVenuesByName() {
        let venues = [venue("3", name: "Third"), venue("1", name: "First"), venue("2", name: "Second")]
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        do {
            try realm.write {
                realm.add(venues)
            }
        } catch {
            print(error)
        }
        let sut = RealmService(with: realm)
        let savedVenues = sut.getVenues()
        
        XCTAssertEqual(savedVenues[0].name, "First")
        XCTAssertEqual(savedVenues[1].name, "Second")
        XCTAssertEqual(savedVenues[2].name, "Third")
    }
    
    func test_getMeals_ReturnsSavedMeals() {
        let testVenue = venue("123", name: "Test")
        let firstMeal = Meal(name: "firstMeal", date: Date(), rating: 5, comment: "first")
        let secondMeal = Meal(name: "seconMeal", date: Date(), rating: 5, comment: "second")
        let thirdMeal = Meal(name: "thirdMeal", date: Date(), rating: 5, comment: "third")
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        do {
            try realm.write {
                testVenue.meals.append(firstMeal)
                testVenue.meals.append(secondMeal)
                testVenue.meals.append(thirdMeal)
                realm.add(testVenue)
            }
        } catch {
            print(error)
        }
        
        let sut = RealmService(with: realm)
        let savedMeals = sut.getMeals(forVenue: testVenue)
        
        XCTAssertEqual(savedMeals.count, 3)
        
        XCTAssertTrue(savedMeals.contains(firstMeal))
        XCTAssertTrue(savedMeals.contains(secondMeal))
        XCTAssertTrue(savedMeals.contains(thirdMeal))
        
        XCTAssertFalse(savedMeals.contains(Meal(name: "fourth", date: Date(), rating: 4, comment: "fourth")))
    }
    
    func test_getMeals_ReturnsSortedMealsByName() {
        let testVenue = venue("123", name: "Test")
        let secondMeal = Meal(name: "secondMeal", date: Date(), rating: 5, comment: "second")
        let thirdMeal = Meal(name: "thirdMeal", date: Date(), rating: 5, comment: "third")
        let firstMeal = Meal(name: "firstMeal", date: Date(), rating: 5, comment: "first")
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        do {
            try realm.write {
                testVenue.meals.append(firstMeal)
                testVenue.meals.append(secondMeal)
                testVenue.meals.append(thirdMeal)
                realm.add(testVenue)
            }
        } catch {
            print(error)
        }
        
        let sut = RealmService(with: realm)
        let savedMeals = sut.getMeals(forVenue: testVenue)
        
        XCTAssertEqual(savedMeals[0].name, "firstMeal")
        XCTAssertEqual(savedMeals[1].name, "secondMeal")
        XCTAssertEqual(savedMeals[2].name, "thirdMeal")
    }
    
    func test_deleteVenue_RemovesVenueFromRealm() {
        let testVenueOne = venue("123", name: "TestOne")
        let testVenueTwo = venue("456", name: "TestTwo")
        let testVenueThree = venue("789", name: "TestThree")
        
        let realm  = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        
        do {
            try realm.write {
                realm.add(testVenueOne)
                realm.add(testVenueTwo)
                realm.add(testVenueThree)
            }
        } catch {
            print(error)
        }
        
        let sut = RealmService(with: realm)
        sut.deleteVenue(id: "123")
        let savedVenues = sut.getVenues()
        
        XCTAssertEqual(savedVenues.count, 2)
    }
    
    func test_deleteVenueAndMeals_RemovesMealsAndVenueFromRealm() {
        let testVenueOne = venue("123", name: "TestOne")
        let testMealOne = Meal(name: "testMealOne", date: Date(), rating: 5, comment: "TestMealOne")
        let testMealTwo = Meal(name: "testMealTwo", date: Date(), rating: 4, comment: "TestMealTwo")
        
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        do {
            try realm.write {
                testVenueOne.meals.append(testMealOne)
                testVenueOne.meals.append(testMealTwo)
                realm.add(testVenueOne)
            }
        } catch {
            print(error)
        }
        
        let sut = RealmService(with: realm)
        sut.deleteVenue(id: "123")
        let savedVenues = sut.getVenues()
        
        XCTAssertEqual(savedVenues.count, 0)
    }
    
    private func venue(_ id: String, name: String) -> Venue {
        let venue = Venue()
        venue.id = id
        venue.name = name
        
        return venue
    }
}
