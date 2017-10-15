//
//  SearchDetailController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/8/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class SearchDetailController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var headerPhotoImageVIew: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var venueAddressLabel: UILabel!
    @IBOutlet weak var venueTelephoneLabel: UILabel!
    @IBOutlet weak var venueWebsiteLabel: UILabel!
    @IBOutlet weak var venuePhotoCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var venue: Venue?
    var client: FoursquareAPIClient?
    
    lazy var collectionViewDataSource: SearchDetailCollectionViewDataSource = {
       return SearchDetailCollectionViewDataSource(venue: self.venue!, client: self.client!)
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        venuePhotoCollectionView.dataSource = collectionViewDataSource
        if let venue = venue, let client = client {
            activityIndicator.startAnimating()
            configure(withViewModel: SearchVenueViewModel(withVenue: venue))
            updateVenueDetails(forVenue: venue, client: client)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func configure(withViewModel viewModel: SearchVenueViewModel) {
        venueNameLabel.text = viewModel.name
        venueAddressLabel.text = viewModel.address
        venueTelephoneLabel.text = viewModel.phoneNumber
        venueWebsiteLabel.text = viewModel.url
    }
    
    func updateVenueDetails(forVenue venue: Venue, client: FoursquareAPIClient) {
        client.updateVenueDetails(venue) { (result) in
            switch result {
            case .success(let venue):
                self.getBestPhoto(forVenue: venue, client: client)
                self.getVenuePhotos(forVenue: venue, client: client)
                return
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getBestPhoto(forVenue venue: Venue, client: FoursquareAPIClient) {
        client.bestPhoto(venue) { (result) in
            switch result {
            case .success(let image):
                UIView.transition(with: self.headerPhotoImageVIew, duration: 0.2, options: .transitionCrossDissolve, animations: { self.headerPhotoImageVIew.image = image}, completion: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getVenuePhotos(forVenue venue: Venue, client: FoursquareAPIClient) {
        client.getPhotos(forVenue: venue) { (result) in
            switch result {
            case .success(let photos):
                self.collectionViewDataSource.update(withPhotos: photos)
                self.activityIndicator.stopAnimating()
                self.venuePhotoCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchDetailController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
