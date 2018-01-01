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
    var locationManager: LocationManager?
    var dataSource: HomeTableViewDataSource?
    private var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let venues = venueService?.getVenues() {
            dataSource = HomeTableViewDataSource(withVenues: venues)
            tableView.dataSource = dataSource
            token = venueService?.observe { [weak self] venueService, venueChanges in
                let venues = venueService.getVenues()
                self?.dataSource?.venues = venues
                switch venueChanges {
                case .initial:
                    self?.tableView.reloadData()
                case .update(let deletions, let insertions, let modifications):
                    self?.tableView.beginUpdates()
                    self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                               with: .automatic)
                    self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                               with: .automatic)
                    self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                               with: .automatic)
                    self?.tableView.endUpdates()
                case .error:
                    fatalError("Internal error")
                }
            }
        }
    }
    
    deinit {
        if let token = token {
            venueService?.stopObserving(token: token)
        }
    }
    
    @IBAction func addMealButtonPressed(_ sender: Any) {
        if locationManager!.checkForLocationServices() {
            let venuePicker = SearchVenuePickerController()
            venuePicker.locationManager = locationManager
            venuePicker.present(fromViewController: self) { [weak self] (venuePicker, searchVenue) in
                self?.addMeal(forSearchVenue: searchVenue, withVenuePicker: venuePicker)
            }
        } else {
            showLocationServicesAlert()
        }
    }
    
    func addMeal(forSearchVenue venue: SearchVenue, withVenuePicker venuePicker: SearchVenuePickerController) {
        let addMealVC = storyboard?.instantiateViewController(withIdentifier: "AddMealController") as! AddMealController
        addMealVC.searchVenue = venue
        addMealVC.venueService = venueService
        addMealVC.completion = { _ in
            venuePicker.dismiss()
        }
        venuePicker.searchNavigation?.setViewControllers([addMealVC], animated: true)
    }
    
    func showLocationServicesAlert() {
        let alertController = UIAlertController(title: "Attention", message: "Unable to search. Please turn on Location Services.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openSettingAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(openSettingAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewContollerDelegate
extension HomeViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let venue = dataSource?.venue(at: indexPath) {
            if let mealVC = storyboard?.instantiateViewController(withIdentifier: "MealViewController") as? MealViewController {
                mealVC.venue = venue
                mealVC.venueServicing = venueService
                navigationController?.pushViewController(mealVC, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            if let venue = self?.dataSource?.venue(at: indexPath) {
                self?.venueService?.deleteVenue(id: venue.id)
            }
        }
        
        return [deleteAction]
    }
}
