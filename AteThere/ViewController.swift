//
//  ViewController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 9/29/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let search = Foursquare.search(term: "jinya")
        print(search.request)
    }
}

