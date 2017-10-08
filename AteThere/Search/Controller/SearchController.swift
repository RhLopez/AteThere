//
//  SearchController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/1/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class SearchController: UITableViewController {
    
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    let client = FoursquareAPIClient()
    let dataSource = SearchContrllerDataSource(venues: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        tableView.dataSource = dataSource
    }
    
    func setupSearchController() {
        self.navigationItem.titleView = searchController.searchBar
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchTerm = searchController.searchBar.text!
        
        if !searchTerm.isEmpty {
            client.search(withTerm: searchTerm) { (result) in
                switch result {
                case .success(let venues):
                    self.dataSource.update(withVenues: venues)
                    self.tableView.reloadData()
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        }
    }
}
