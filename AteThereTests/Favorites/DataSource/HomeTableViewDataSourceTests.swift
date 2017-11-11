//
//  HomeTableViewDataSourceTests.swift
//  AteThereTests
//
//  Created by Ramiro H Lopez on 10/30/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import XCTest
@testable import AteThere
import RealmSwift

class HomeTableViewDataSourceTests: XCTestCase {
    
    func test_DataSourceVenuesCount_EqualRealmVenuesCount() {
        let service = VenueServiceMock(withVenues: [venue("1", name: "First"), venue("2", name: "Second"), venue("3", name: "Third")])
        let venues = service.getVenues()
        let sut = HomeTableViewDataSource(withVenues: venues)
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), venues.count)
    }
    
    func test_DataSourceGetVenue_ReturnsVenueAtIndex() {
        let venues: [Venue] = [venue("1", name: "First"), venue("2", name: "Second"), venue("3", name: "Third")]
        let sut = HomeTableViewDataSource(withVenues: venues)
        let indexPath = IndexPath(row: 1, section: 0)
        let savedVenue = sut.venue(at: indexPath)
        XCTAssertEqual(savedVenue, venues[1]) 
    }
}

private func venue(_ id: String, name: String) -> Venue {
    let venue = Venue()
    venue.id = id
    venue.name = name
    
    return venue
}
