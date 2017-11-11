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
    
    var imageCache = NSCache<NSString,UIImage>()
    var fileManagerService = FileManagerService()

    override func layoutSubviews() {
        super.layoutSubviews()
        firstMealPhoto.layer.cornerRadius = 3
    }
    
    func configure(withViewModel viewModel: HomeVenueViewModel) {
        venueName.text = viewModel.name
        venueCategory.text = viewModel.category
        loadImage(forPath: viewModel.photoPath)
    }
    
    // Mark: - Helper Method
    func loadImage(forPath path: String?) {
        if let photoPath = path {
            if let image = imageCache.object(forKey: photoPath as NSString) {
                firstMealPhoto.image = image
            } else {
                fileManagerService.loadImage(withPath: photoPath, completion: { (image) in
                    if let image = image {
                        UIView.transition(with: self.firstMealPhoto, duration: 0.2, options: .transitionCrossDissolve, animations: { self.firstMealPhoto.image = image }, completion: nil)
                        self.imageCache.setObject(image, forKey: photoPath as NSString)
                    }
                })
            }
        }
    }
}
