//
//  HomeTableViewCell.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/29/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueCategory: UILabel!
    @IBOutlet weak var firstMealPhoto: UIImageView!
    
    static var identifier: String {
        return String(describing: HomeTableViewCell.self)
    }
    
    func configure(withViewModel viewModel: HomeVenueViewModel) {
        self.venueName.text = viewModel.name
        self.venueCategory.text = viewModel.category
        // TODO: Assign first meal photo to UIImageView
    }
}
