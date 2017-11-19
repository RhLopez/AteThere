//
//  MealViewController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 11/9/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class MealViewController: UICollectionViewController {
    
    // MARK: - Properties
    var venue: Venue?
    var venueServicing: VenueServicing?
    var dataSource: MealControllerDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let venue = venue else { return }
        title = venue.name
        if let meals = venueServicing?.getMeals(forVenue: venue) {
            dataSource = MealControllerDataSource(withMeals: meals)
            collectionView?.dataSource = dataSource
        }
    }
}
