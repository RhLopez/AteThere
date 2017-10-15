//
//  SearchDetailCollectionViewCell.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/14/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class SearchDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var venueImageView: UIImageView!
    
    static var identifier: String {
        return String(describing: SearchDetailCollectionViewCell.self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        venueImageView.layer.cornerRadius = 3.0
    }
    
    func updateCell(withImage image: UIImage) {
        UIView.transition(with: venueImageView, duration: 0.2, options: .transitionCrossDissolve, animations: { self.venueImageView.image = image}, completion: nil)
    }
}
