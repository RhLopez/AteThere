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
    
    var sut: MealViewController?
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        sut = storyboard.instantiateViewController(withIdentifier: "MealViewController") as? MealViewController
    }
    
    func test_ViewDidLoad_CollectionViewIsNotNil() {
        XCTAssertNotNil(sut?.collectionView)
    }
}
