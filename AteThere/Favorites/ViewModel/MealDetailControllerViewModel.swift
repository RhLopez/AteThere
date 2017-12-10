//
//  MealDetailControllerViewModel.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 11/20/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

struct MealDetailControllerViewModel {
    
    let meal: Meal
    
    init(withMeal meal: Meal) {
        self.meal = meal
    }
    
    var rating: Int {
        return meal.rating
    }
    
    var name: String {
        return meal.name
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: meal.date)
    }
    
    var comment: String {
        return meal.comment
    }
    
    var mealPhotoPath: String {
        return meal.photoPath
    }
}
