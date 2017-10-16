//
//  CustomTextField.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/15/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeTextField()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customizeTextField()
    }
    
    private func customizeTextField() {
        let width = CGFloat(0.9)
        let border = CALayer()
        
        border.borderColor = UIColor.lightGray.cgColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: bounds.size.height - width, width: bounds.size.width, height: bounds.size.height)
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
