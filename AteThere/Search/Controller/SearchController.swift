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
    let dataSource = SearchControllerDataSource()
    
    lazy var apiKey: APIKey = {
        // Add clientID and clientSecret to FoursquareAPIKey.swift
        // or replace with a different type
       return FoursquareAPIKey()
    }()
    
    lazy var client: FoursquareAPIClient = {
       return FoursquareAPIClient(apiKey: self.apiKey)
    }()
    
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

// MARK: - UISearchResultsUpdating
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

// MARK: - UITableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let venue = dataSource.getVenue(forIndexPath: indexPath)
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "SearchDetailController") as! SearchDetailController
        detailViewController.viewModel = SearchVenueViewModel(withVenue: venue)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
