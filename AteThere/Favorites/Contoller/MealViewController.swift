//
//  MealViewController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 11/9/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class MealViewController: UICollectionViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Properties
    var venue: Venue?
    var venueServicing: VenueServicing?
    var dataSource: MealControllerDataSource?
    var animator = ExpandAnimator()
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let venue = venue else { return }
        title = venue.name
        if let meals = venueServicing?.getMeals(forVenue: venue) {
            dataSource = MealControllerDataSource(withMeals: meals)
            collectionView?.dataSource = dataSource
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MealViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let meal = dataSource?.meal(at: indexPath),
            let cell = collectionView.cellForItem(at: indexPath) as? MealCollectionViewCell {
            
            self.selectedIndexPath = indexPath
            
            animator.selectedCell = cell
            animator.selectedCellFrame = cell.superview!.convert(cell.frame, to: nil)
            let mealDetailVC = storyboard?.instantiateViewController(withIdentifier: "MealDetailController") as! MealDetailController
            mealDetailVC.meal = meal
            mealDetailVC.mealImage = cell.mealImageView.image
            mealDetailVC.transitioningDelegate = self
            present(mealDetailVC, animated: true, completion: nil)
        }
    }
}

// MARK: - UIViewControllerTransitionDelegate
extension MealViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = true
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
}
