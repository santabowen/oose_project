//
//  ProfileRatingView.swift
//  LetsGo
//
//  Created by Chen Wang on 11/25/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit

class ProfileRatingView: UIView {

    
    // MARK: Properties
    
    var rating = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var ratingButtons = [UIButton]()
    var spacing = 0
    var stars = 0.0
    
    
    // MARK: Initialization
    func show() {
        ratingButtons.removeAll()
        
        let filledStarImage = UIImage(named: "filled_star")
        let halfStarImage = UIImage(named: "half_star")
        var tempStar = stars
        
        while tempStar > 0 {
            print("star = \(tempStar)")
            let button = UIButton()
            button.enabled = false
            var addButton = false
            if tempStar >= 1.0 {
                addButton = true
                button.setImage(filledStarImage, forState: .Normal)
                button.setImage(filledStarImage, forState: .Selected)
                button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            } else if tempStar - 0.5 >= 0 {
                addButton = true
                button.setImage(halfStarImage, forState: .Normal)
                button.setImage(halfStarImage, forState: .Selected)
                button.setImage(halfStarImage, forState: [.Highlighted, .Selected])
            }
            
            if addButton {
                button.adjustsImageWhenHighlighted = false
                
                button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchDown)
                ratingButtons += [button]
                addSubview(button)
            }
            tempStar -= 1.0
        }
    }
    
    
    override func layoutSubviews() {
        // Set the button's width and height to a square the size of the frame's height.
        let buttonSize = 36//Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus some spacing.
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
    }
    
    
    /// This function sets the content of each table view cell
    /// - parameter activity: (Activity) see in the model group. A self-defined class for each activity
    func updateRating(num: Double) {
        stars = num
        spacing = 5
    }

}
