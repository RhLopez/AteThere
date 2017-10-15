//
//  CustomUIButton.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/14/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import UIKit

class CustomUIButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        layer.cornerRadius = 5.0
        layer.shadowRadius = 5
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 2.0
    }
}
