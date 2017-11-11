//
//  MealViewControllerTests.swift
//  AteThereTests
//
//  Created by Ramiro H Lopez on 11/9/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import XCTest
@testable import AteThere

class MealViewControllerTests: XCTestCase {
    
    func test_ViewDidLoad_TableViewIsNotNil() {
        let sut = MealViewController()
        _ = sut.view
        XCTAssertNotNil(sut.tableView)
    }
}
