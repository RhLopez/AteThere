//
//  MealDetailController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 11/20/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class MealDetailController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mealImageVIew: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealDateLabel: UILabel!
    @IBOutlet weak var mealCommentLabel: UILabel!
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var detailContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailContainerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailContainerLeftConstraint: NSLayoutConstraint!

    
    // MARK: - Properties
    var meal: Meal?
    var mealImage: UIImage?
    var fileManagerService = FileManagerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let meal = meal else { return }
        mealImageVIew.image = mealImage
        let viewModel = MealDetailControllerViewModel(withMeal: meal)
        configure(withViewModel: viewModel)
    }
    
    func configure(withViewModel viewModel: MealDetailControllerViewModel) {
        ratingControl.rating = viewModel.rating
        mealNameLabel.text = viewModel.name
        mealDateLabel.text = viewModel.date
        mealCommentLabel.text = viewModel.comment
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
