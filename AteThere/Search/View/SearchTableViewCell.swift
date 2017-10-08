//
//  SearchTableViewCell.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/7/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    static var identifier: String {
        return String(describing: SearchTableViewCell.self)
    }
    
    func update(withViewModel viewModel: SearchVenueViewModel) {
        self.nameLabel.text = viewModel.name
        self.addressLabel.text = viewModel.address
    }
}
