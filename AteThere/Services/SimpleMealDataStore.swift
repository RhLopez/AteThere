//
//  MealDataStore.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/19/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

protocol SimpleMealStorageProtocol {
    func store(meals: [Meal])
    func load() -> [Meal]
}

class SimpleMealDataStore: MealDataStoreProtocol {
    private var meals = [Meal]()
    private var storage: SimpleMealStorageProtocol
    
    init(withStorage storage: SimpleMealStorageProtocol) {
        self.storage = storage
        self.meals = storage.load()
    }

    func add(meal: Meal) {
        meals.append(meal)
        storage.store(meals: meals)
    }

    func contains(meal: Meal) -> Bool {
        return meals.contains(where: { (anotherMeal) -> Bool in
            return anotherMeal.id == meal.id
        })
    }

    func getMeal(id: String) -> Meal? {
        return meals.first(where: { (meal) -> Bool in
            return meal.id == id
        })
    }
    
    func delete(byId id: String) {
        meals = meals.filter({ (meal) -> Bool in
            return meal.id != id
        })
        storage.store(meals: meals)
    }
}
