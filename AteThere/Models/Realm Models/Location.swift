//
//  Location.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/28/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic var address = ""
    @objc dynamic var latitude: Double = 0.00
    @objc dynamic var longitude: Double = 0.00
    
    convenience init(withSearchLocation location: SearchLocation) {
        self.init()
        self.address = location.address
        self.latitude = location.latitude
        self.longitude = location.longitude
    }
}
