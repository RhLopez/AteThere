//
//  RatingControl.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/21/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import UIKit

class RatingControl: UIStackView {
    
    // MARK: - Properties
    var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectedState()
        }
    }
    
    // MARK: - Initialization
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    @objc private func buttonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            print("Error button not in array")
            return
        }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    private func setupButtons() {
        for item in self.arrangedSubviews {
            guard let button = item as? UIButton else {
                return
            }
            
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            
            let empty = UIImage(named: "grayStar")
            let highlighted = UIImage(named: "highlightedStar")
            let filled = UIImage(named: "filledStar")
            
            button.setImage(empty, for: .normal)
            button.setImage(filled, for: .selected)
            button.setImage(highlighted, for: .highlighted)
            button.setImage(highlighted, for: [.highlighted, .selected])
            
            ratingButtons.append(button)
        }
        
        updateButtonSelectedState()
    }
    
    private func updateButtonSelectedState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
