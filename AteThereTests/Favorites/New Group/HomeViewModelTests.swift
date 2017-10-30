//
//  HomeVenueViewModel.swift
//  AteThereTests
//
//  Created by Ramiro H Lopez on 10/29/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import XCTest
@testable import AteThere

class HomeVenueViewModelTests: XCTestCase {
    
    func test_CategoryStringReturnsEmptyString_IfCategoryIsNil() {
        let venue = Venue()
        let sut = HomeVenueViewModel(withVenue: venue)
        XCTAssertEqual(sut.category, "")
    }
    
    func test_PhotoPathReturns_PhotoPathOfFirstMeal() {
        let venue = Venue()
        let firstMeal = Meal(name: "first", date: Date(), rating: 1, comment: "fistComment")
        let secondMeal = Meal(name: "Second", date: Date(), rating: 2, comment: "secondComment")
        XCTAssertNotEqual(firstMeal.photoPath, secondMeal.photoPath)
        venue.meals.append(firstMeal)
        venue.meals.append(secondMeal)
        let sut = HomeVenueViewModel(withVenue: venue)
        XCTAssertEqual(sut.photoPath, firstMeal.photoPath)
    }
}
