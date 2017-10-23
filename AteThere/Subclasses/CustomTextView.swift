//
//  CustomTextView.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/22/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func styleTextView() {
        let border = CALayer()
        let width = CGFloat(0.9)
        
        border.borderColor = UIColor.lightGray.cgColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: bounds.size.width, height: width)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.layer.sublayers!.count > 1 {
            let lastLayer = self.layer.sublayers?.last
            lastLayer?.removeFromSuperlayer()
        }
        styleTextView()
    }
}
