//
//  APIKey.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/10/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

protocol APIKey {
    var clientID: String { get set }
    var clientSecret: String { get set }
    
    init(clientID: String, clientSecret: String)
}
