//
//  MealControllerViewModel.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 11/10/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

struct MealControllerViewModel {
    let meal: Meal
    
    init(withMeal meal: Meal) {
        self.meal = meal
    }
    
    var name: String {
        return meal.name
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: meal.date)
    }
    
    var photoPath: String {
        return meal.photoPath
    }
}
