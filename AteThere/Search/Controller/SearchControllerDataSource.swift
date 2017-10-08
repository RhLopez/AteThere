//
//  SearchControllerDataSource.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/7/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class SearchControllerDataSource: NSObject {
    private var venues: [Venue]
    
    init(venues: [Venue]) {
        self.venues = venues
    }
    
    override convenience init() {
        self.init(venues: [])
    }
}

// MARK: - UITableViewDataSource
extension SearchControllerDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell {
            
            let venue = venues[indexPath.row]
            let viewModel = SearchVenueViewModel(withVenue: venue)
            cell.update(withViewModel: viewModel)
            
            return cell
        } else {
           return UITableViewCell()
        }
    }
}

extension SearchControllerDataSource {
    func update(withVenues venues: [Venue]) {
        self.venues = venues
    }
}
