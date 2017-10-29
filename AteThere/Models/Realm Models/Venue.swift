//
//  Venue.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/27/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import RealmSwift

class Venue: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var cateogry: String? = nil
    
    var locations = List<Location>()
    var meals = List<Meal>()

    convenience init(withSearchVenue venue: SearchVenue) {
        self.init()
        self.id = venue.id
        self.name = venue.name
        self.cateogry = venue.category?.categoryName
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
