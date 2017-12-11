//
//  MealCollectionViewCell.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 11/10/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    
    static var identifier: String {
        return String(describing: MealCollectionViewCell.self)
    }
    
    var imageCache = NSCache<NSString,UIImage>()
    var fileManagerService = FileManagerService()
    
    override func layoutSubviews() {
        super.layoutSubviews()        
        self.layer.cornerRadius = 6
    }
    
    func configure(withViewModel viewModel: MealControllerViewModel) {
        mealNameLabel.text = viewModel.name
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
                        self.mealImageView.image = image
                        self.imageCache.setObject(image, forKey: photoPath as NSString)
                    }
                })
            }
        }
    }
}
