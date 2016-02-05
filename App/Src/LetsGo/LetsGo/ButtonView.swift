//
//  ButtonView.swift
//  LetsGo
//
//  Created by Chen Wang on 11/30/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit

class ButtonView: UIButton {

    /// a nice look view file to set how a button looks 
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = baseColor.CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 8.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }

}
