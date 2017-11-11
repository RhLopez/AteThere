//
//  HomeTableViewDataSource.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/30/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class HomeTableViewDataSource: NSObject {
    
    private var venues: [Venue]
    
    init(withVenues venues: [Venue]) {
        self.venues = venues
    }
}

extension HomeTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell {
            let venue = venues[indexPath.row]
            cell.configure(withViewModel: HomeVenueViewModel(withVenue: venue))
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - Helper Method
extension HomeTableViewDataSource {
    func venue(at indexPath: IndexPath) -> Venue {
        return venues[indexPath.row]
    }
}
