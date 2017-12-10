//
//  MealControllerDataSource.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 11/10/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class MealControllerDataSource: NSObject {
    private var meals: [Meal]
    
    init(withMeals meals: [Meal]) {
        self.meals = meals
    }
}

// MARK: - UICollectionViewDataSource
extension MealControllerDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCollectionViewCell.identifier, for: indexPath) as? MealCollectionViewCell {
            let meal = meals[indexPath.row]
            cell.configure(withViewModel: MealControllerViewModel(withMeal: meal))
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - Helper methods
extension MealControllerDataSource {
    func meal(at indexPath: IndexPath) -> Meal {
        return meals[indexPath.row]
    }
}
