//
//  MealControllerDataSourceTests.swift
//  AteThereTests
//
//  Created by Ramiro H Lopez on 11/10/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import XCTest
@testable import AteThere
import RealmSwift

class MealControllerDataSourceTests: XCTestCase {
    
    func test_DataSourceMealCount_EqualRealmMealCount() {
        let firstMeal = Meal(name: "firstMeal", date: Date(), rating: 4, comment: "first")
        let secondMeal = Meal(name: "secondMeal", date: Date(), rating: 5, comment: "second")
        let thirdMeal = Meal(name: "thirdMeal", date: Date(), rating: 1, comment: "third")
        let testVenue = venue("1", name: "testVenue")
        testVenue.meals.append(firstMeal)
        testVenue.meals.append(secondMeal)
        testVenue.meals.append(thirdMeal)
        let service = VenueServiceMock(withVenues: [testVenue])
        let meals = service.getMeals(forVenue: testVenue)
        
        let sut = MealControllerDataSource(withMeals: meals)
//        XCTAssertEqual(sut.collectionView(UICollectionView(), numberOfItemsInSection: 0), meals.count)
        //XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), meals.count)
    }
}

private func venue(_ id: String, name: String) -> Venue {
    let venue = Venue()
    venue.id = id
    venue.name = name
    
    return venue
}
