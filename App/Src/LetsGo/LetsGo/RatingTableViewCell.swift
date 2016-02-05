//
//  RatingTableViewCell.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 11/9/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit


/// A class that manage the cell view in the rating table.
class RatingTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel! 
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    var uid: Int?
    
    var rating: Rating? {
        didSet{
            updateUI()
        }
    }

    func updateUI(){
        
    }
}
