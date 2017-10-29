//
//  Meal.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/19/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import RealmSwift

class Meal: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var date = Date()
    @objc dynamic var rating: Int = 0
    @objc dynamic var comment: String = ""
    @objc dynamic var photoPath: String = ""
    
    convenience init(name: String, date: Date, rating: Int, comment: String) {
        self.init()
        self.id = NSUUID().uuidString
        self.name = name
        self.date = date
        self.rating = rating
        self.comment = comment
        self.photoPath = self.id
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
