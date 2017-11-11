//
//  AteThereRootNavigationController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/29/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class AteThereRootNavigationController: UINavigationController {
    
    lazy var venueService: RealmService = {
       return RealmService()
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let rootVC = viewControllers[0] as? HomeViewController {
            rootVC.venueService = self.venueService
        }
        
    }
}
