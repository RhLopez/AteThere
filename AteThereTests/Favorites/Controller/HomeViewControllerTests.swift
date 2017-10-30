//
//  HomeViewControllerTests.swift
//  AteThereTests
//
//  Created by Ramiro H Lopez on 10/29/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import XCTest
@testable import AteThere
import RealmSwift

class HomeViewControllerTests: XCTestCase {
    
    func test_ViewDidLoad_TableViewIsNotNil() {
        let sut = HomeViewController()
        _ = sut.view
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_viewDidLoad_tableViewContainsAllVenuesInRealm() {
        let sut = HomeViewController()
        sut.venueService = VenueServiceMock(withVenues: [venue("1", name: "First"), venue("2", name: "Second"), venue("3", name: "Third")])
        _ = sut.view
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 3)
    }
}

class VenueServiceMock: VenueServicing {
    let venues: [Venue]
    
    init(withVenues venues: [Venue]) {
        self.venues = venues
    }
    
    func getVenues() -> [Venue] {
        return venues
    }
}


private func venue(_ id: String, name: String) -> Venue {
    let venue = Venue()
    venue.id = id
    venue.name = name
    
    return venue
}
