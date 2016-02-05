//
//  RatingControl.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 11/13/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit

/// A class that manage the rating stars
class RatingControl: UIView {
    // MARK: Properties
    
    var rating = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var initRating: Double?
    
    var ratingButtons = [UIButton]()
    var spacing = 5
    var stars = 5
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let emptyStarImage = UIImage(named: "empty_star")
        let filledStarImage = UIImage(named: "filled_star")
        
        for _ in 0..<stars {
            let button = UIButton()
            
            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            
            button.adjustsImageWhenHighlighted = false
            
            button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchDown)
            ratingButtons += [button]
            addSubview(button)
        }
    }
    
    // add star to the subview
    override func layoutSubviews() {
        // Set the button's width and height to a square the size of the frame's height.
        let buttonSize = 28//Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus some spacing.
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        
        updateButtonSelectionStates()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + spacing) * stars
        
        return CGSize(width: width, height: buttonSize)
    }

    /**
     When a rating button has been tapped, change the rating button view.
     */
    func ratingButtonTapped(button: UIButton) {
        // disable the button if the user has been rated.
        if initRating! == -1 {
            rating = Double(ratingButtons.indexOf(button)!) + 1.0
            updateButtonSelectionStates()
        }
    }
    
    // update the rating button according to the chosen rating number.
    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerate() {
            // If the index of a button is less than the rating, that button should be selected.
            button.selected = index < Int(ceil(rating))
        }
    }
}
