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
    
    @IBAction func addMealButtonPressed(_ sender: Any) {
        let venuePicker = SearchVenuePickerController()
        venuePicker.present(fromViewController: self) { [weak self] (venuePicker, searchVenue) in
            self?.addMeal(forSearchVenue: searchVenue, withVenuePicker: venuePicker)
        }
    }
    
    func addMeal(forSearchVenue venue: SearchVenue, withVenuePicker venuePicker: SearchVenuePickerController) {
        let addMealVC = storyboard?.instantiateViewController(withIdentifier: "AddMealController") as! AddMealController
        addMealVC.searchVenue = venue
        addMealVC.venueService = venueService
        addMealVC.completion = { [weak self] _ in
            if let venues = self?.venueService?.getVenues() {
                self?.dataSource = HomeTableViewDataSource(withVenues: venues)
                self?.tableView.dataSource = self?.dataSource
                self?.tableView.reloadData()
            }
            venuePicker.dismiss()
        }
        venuePicker.searchNavigation?.setViewControllers([addMealVC], animated: true)
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
}
