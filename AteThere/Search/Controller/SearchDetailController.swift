//
//  SearchDetailController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/8/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

protocol SearchDetailControllerDelegate: class {
    func searchDetailController(_ searchDetailController: SearchDetailController, didSelect searchVenue: SearchVenue?)
}

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
    var searchVenue: SearchVenue?
    var client: FoursquareAPIClient?
    weak var delegate: SearchDetailControllerDelegate?
    
    lazy var collectionViewDataSource: SearchDetailCollectionViewDataSource = {
       return SearchDetailCollectionViewDataSource(venue: self.searchVenue!, client: self.client!)
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        venuePhotoCollectionView.dataSource = collectionViewDataSource
        if let venue = searchVenue, let client = client {
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
    
    func updateVenueDetails(forVenue venue: SearchVenue, client: FoursquareAPIClient) {
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
    
    func getBestPhoto(forVenue venue: SearchVenue, client: FoursquareAPIClient) {
        client.bestPhoto(venue) { (result) in
            switch result {
            case .success(let image):
                UIView.transition(with: self.headerPhotoImageVIew, duration: 0.2, options: .transitionCrossDissolve, animations: { self.headerPhotoImageVIew.image = image}, completion: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getVenuePhotos(forVenue venue: SearchVenue, client: FoursquareAPIClient) {
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
    
    // MARK: - IBActions
    @IBAction func selectButtonPressed(_ sender: CustomUIButton) {
        delegate?.searchDetailController(self, didSelect: searchVenue)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        delegate?.searchDetailController(self, didSelect: nil)
    }
}

// MARK: - UIGesturesRecognizerDelegate
extension SearchDetailController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
