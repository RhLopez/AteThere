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
    
    // MARK: - Properties
    var viewModel: SearchVenueViewModel?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        if let viewModel = viewModel {
            configure(withViewModel: viewModel)
        }
    }
    
    func configure(withViewModel viewModel: SearchVenueViewModel) {
        venueNameLabel.text = viewModel.name
        venueAddressLabel.text = viewModel.address
        venueTelephoneLabel.text = viewModel.phoneNumber
        venueWebsiteLabel.text = viewModel.url
    }
}
