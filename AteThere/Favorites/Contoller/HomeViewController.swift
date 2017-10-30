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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


// Mark: - TableViewDataSource
extension HomeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueService?.getVenues().count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath)
        cell.textLabel?.text = venueService?.getVenues()[indexPath.row].name
        return cell
    }
}
