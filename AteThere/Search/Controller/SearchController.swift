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
    
    lazy var client: FoursquareAPIClient = {
       return FoursquareAPIClient(apiKey: FoursquareAPIKey())
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        tableView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func setupSearchController() {
        self.navigationItem.titleView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self

        let textfield = self.searchController.searchBar.value(forKey: "searchField") as! UITextField
        textfield.tintColor = .black
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
        } else {
            self.dataSource.update(withVenues: [])
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let venue = dataSource.getVenue(forIndexPath: indexPath)
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "SearchDetailController") as! SearchDetailController
        detailViewController.venue = venue
        detailViewController.client = client
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
