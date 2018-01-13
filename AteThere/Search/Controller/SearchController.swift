//
//  SearchController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/1/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol SearchControllerDelegate: class {
    func searchController(_ searchController: SearchController, didSelect searchVenue: SearchVenue?)
}

class SearchController: UITableViewController {
    
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    let dataSource = SearchControllerDataSource()
    var client: FoursquareAPIClient?
    var locationManager: LocationManager?
    private var lastSearchTerm: String?
    weak var delegate: SearchControllerDelegate?
    let userDefaults = UserDefaults()
    var coordinates: CLLocationCoordinate2D?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        tableView.dataSource = dataSource
        locationManager?.locationPermissionDelegate = self
        locationManager?.delegate = self
        checkLocationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let savedTerm = lastSearchTerm {
            searchController.searchBar.text = savedTerm
            searchController.isActive = true
        }
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lastSearchTerm = searchController.searchBar.text
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.isActive = false
    }
    
    func checkLocationAuthorization() {
        do {
            try locationManager?.requestLocationAuthorization()
        } catch {
            showLocationDeniedMessage()
        }
    }
    
    func setupSearchController() {
        navigationItem.titleView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        let textfield = self.searchController.searchBar.value(forKey: "searchField") as! UITextField
        textfield.tintColor = .black
        
        locationManager?.requestLocation()
    }
    
    func showLocationDeniedMessage() {
        let alertController = UIAlertController(title: "Attention", message: "In order to search your location is needed.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        
        let openSettingAction = UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return }
            if let url = URL(string: UIApplicationOpenSettingsURLString + bundleIdentifier) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(openSettingAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func showRestrictedLocationAccessMessage() {
        let message = "Restricted Location Services access identified./nLocation Services needs to be turned on in order to use this application"
        let alertController = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - LocationPermissionDelegate
extension SearchController: LocationPermissionDelegate {    
    func authorizationFailedWithStatus(_ error: LocationError) {
        switch error {
        case .deniedByUser:
            showLocationDeniedMessage()
        case .restrictedAccess:
            showRestrictedLocationAccessMessage()
        default:
            return
        }
    }
}

// MARK: - LocationManagerDelegate
extension SearchController: LocationManagerDelegate {
    func obtainedCoordinates(_ coordinate: CLLocationCoordinate2D) {
        coordinates = coordinate
    }
    
    func failedWithError(_ error: LocationError) {
        // TODO: Implement show general message
    }
}

// MARK: - UISearchBarDelegate
extension SearchController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UISearchResultsUpdating
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchTerm = searchController.searchBar.text!
        if let coordinate = coordinates {
            if !searchTerm.isEmpty {
                client?.search(withTerm: searchTerm, withCoordinate: coordinate) { (result) in
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
}

// MARK: - UITableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchVenue = dataSource.getVenue(forIndexPath: indexPath)
        searchController.searchBar.resignFirstResponder()
        delegate?.searchController(self, didSelect: searchVenue)
        
    }
}
