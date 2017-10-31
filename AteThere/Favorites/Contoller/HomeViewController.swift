//
//  HomeViewController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/29/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    var venueService: VenueServicing?
    var dataSource: HomeTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let venues = venueService?.getVenues() {
            dataSource = HomeTableViewDataSource(withVenues: venues)
            tableView.dataSource = dataSource
        }
    }
}
