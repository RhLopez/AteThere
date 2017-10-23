//
//  MealDataStoreTest.swift
//  AteThereTests
//
//  Created by Ramiro H Lopez on 10/19/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import XCTest

@testable import AteThere

class MealDataStoreTest: XCTestCase {
    
    func test_AddMeal_Should_Call_Store_On_Meal_Storage() {
        let storage = FakeMealStorage()
        let sut = SimpleMealDataStore(withStorage: storage)
        let meal = Meal(id: "sample")
        sut.add(meal: meal)
        XCTAssertTrue(storage.storeMethodWasCalled)
    }
    
    func test_AddMeal_Should_Add_Meal_To_List_Of_Stored_Meals() {
        let storage = FakeMealStorage()
        let sut = SimpleMealDataStore(withStorage: storage)
        let meal = Meal(id: "123")
        sut.add(meal: meal)
        XCTAssertEqual(storage.storedMeals.last?.id, meal.id)
    }
    
    func test_Adding_Two_Meals_Should_Add_Two_Meals_To_List_Of_Stored_Meals() {
        let storage = FakeMealStorage()
        let sut = SimpleMealDataStore(withStorage: storage)
        let firstMeal = Meal(id: "123")
        let secondMeal = Meal(id: "sample")
        sut.add(meal: firstMeal)
        sut.add(meal: secondMeal)
        XCTAssertEqual(storage.storedMeals.first?.id, firstMeal.id)
        XCTAssertEqual(storage.storedMeals.last?.id, secondMeal.id)
    }

    func test_Contains_Returns_False_When_DataStore_Does_Not_Contain_Meal() {
        let storage = FakeMealStorage()
        let meal = Meal(id: "123")
        let anotherMeal = Meal(id: "sample")
        storage.storedMeals = [meal]
        let sut = SimpleMealDataStore(withStorage: storage)
        let r = sut.contains(meal: anotherMeal)
        XCTAssertFalse(r)
    }
    
    func test_Contains_Returns_True_When_DataStore_Contains_Meal() {
        let storage = FakeMealStorage()
        let meal = Meal(id: "123")
        storage.storedMeals = [meal]
        let sut = SimpleMealDataStore(withStorage: storage)
        XCTAssertTrue(sut.contains(meal: Meal(id: "123")))
    }

    func test_GetMeal_Returns_Nil_When_DataStore_Does_Not_Contain_Meal() {
        let storage = FakeMealStorage()
        let meal = Meal(id: "123")
        let anotherMeal = Meal(id: "sample")
        storage.storedMeals = [meal]
        let sut = SimpleMealDataStore(withStorage: storage)
        let r = sut.getMeal(id: anotherMeal.id)
        XCTAssertNil(r)
    }
    
    func test_GetMeal_Returns_Meal_When_DataStore_Contains_Meal() {
        let storage = FakeMealStorage()
        let meal = Meal(id: "123")
        storage.storedMeals = [meal]
        let sut = SimpleMealDataStore(withStorage: storage)
        let retrievedMeal = sut.getMeal(id: "123")
        XCTAssertEqual(retrievedMeal?.id, "123")
    }
    
    func test_After_DeleteMeal_DataStore_Should_Not_Contain_Meal() {
        let storage = FakeMealStorage()
        let meal = Meal(id: "123")
        storage.storedMeals = [meal]
        let sut = SimpleMealDataStore(withStorage: storage)
        sut.delete(byId: "123")
        XCTAssertFalse(storage.storedMeals.contains(where: { (meal) -> Bool in
            return meal.id == "123"
        }))
    }
}

class FakeMealStorage: SimpleMealStorageProtocol {
    var storedMeals = [Meal]()
    var storeMethodWasCalled: Bool = false
    
    func store(meals: [Meal]) {
        storedMeals = meals
        storeMethodWasCalled = true
    }
    
    func load() -> [Meal] {
        return storedMeals
    }
}
