//
//  VenuePickerControllerTests.swift
//  AteThereTests
//
//  Created by Ramiro H Lopez on 11/4/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import XCTest
@testable import AteThere

class VenuePickerControllerTests: XCTestCase {
    
    func test_Present() {
        let sut = SearchVenuePickerController()
        sut.present { searchVenue in
            print(searchVenue)
        }
    }
}
