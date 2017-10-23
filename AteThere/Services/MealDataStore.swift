//
//  MealDataStore.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/22/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

protocol MealDataStoreProtocol {
    func add(meal: Meal)
    func contains(meal: Meal) -> Bool
    func getMeal(id: String) -> Meal?
    func delete(byId: String)
}
