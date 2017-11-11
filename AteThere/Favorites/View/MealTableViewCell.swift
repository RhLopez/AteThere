//
//  MealTableViewCell.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 11/10/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealDateLabel: UILabel!
    
    static var identifier: String {
        return String(describing: MealTableViewCell.self)
    }
    
    var imageCache = NSCache<NSString,UIImage>()
    var fileManagerService = FileManagerService()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mealImageView.layer.cornerRadius = 3
    }
    
    func configure(withViewModel viewModel: MealControllerViewModel) {
        mealNameLabel.text = viewModel.name
        mealDateLabel.text = viewModel.date
        loadImage(forPath: viewModel.photoPath)
    }

    // Mark: - Helper Method
    func loadImage(forPath path: String?) {
        if let photoPath = path {
            if let image = imageCache.object(forKey: photoPath as NSString) {
                mealImageView.image = image
            } else {
                fileManagerService.loadImage(withPath: photoPath, completion: { (image) in
                    if let image = image {
                        UIView.transition(with: self.mealImageView, duration: 0.2, options: .transitionCrossDissolve, animations: { self.mealImageView.image = image }, completion: nil)
                        self.imageCache.setObject(image, forKey: photoPath as NSString)
                    }
                })
            }
        }
    }
}
