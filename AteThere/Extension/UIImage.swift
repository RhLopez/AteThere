//
//  UIImage.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 11/5/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func scaleImageToSize(img: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        img.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
