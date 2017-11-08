//
//  VenuePickerController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 11/4/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class SearchVenuePickerController {
    
    private var ownReference: SearchVenuePickerController?
    private var completion: ((SearchVenuePickerController, SearchVenue) -> Void)?
    weak var searchNavigation: UINavigationController?
    
    lazy var client: FoursquareAPIClient = {
        return FoursquareAPIClient(apiKey: FoursquareAPIKey())
    }()
    
    func present(fromViewController viewController: UIViewController, completion: @escaping (SearchVenuePickerController, SearchVenue) -> Void) {
        ownReference = self
        self.completion = completion
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchNavigation = storyboard.instantiateViewController(withIdentifier: "SearchNavigationContoller") as! UINavigationController
        self.searchNavigation = searchNavigation
        if let searchController = searchNavigation.viewControllers.first as? SearchController {
            searchController.client = client
            searchController.delegate = self
        }
        viewController.present(searchNavigation, animated: true, completion: nil)
    }
    
    func dismiss() {
        searchNavigation?.dismiss(animated: true, completion: nil)
        ownReference = nil
    }
}

extension SearchVenuePickerController: SearchControllerDelegate {
    func searchController(_ searchController: SearchController, didSelect searchVenue: SearchVenue?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "SearchDetailController") as! SearchDetailController
        detailViewController.searchVenue = searchVenue
        detailViewController.client = client
        detailViewController.delegate = self
        searchController.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension SearchVenuePickerController: SearchDetailControllerDelegate {
    func searchDetailController(_ searchDetailController: SearchDetailController, didSelect searchVenue: SearchVenue?) {
        guard let venue = searchVenue else {
            dismiss()
            return
        }
        completion?(self, venue)
    }
}
