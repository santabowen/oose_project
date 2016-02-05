//
//  Rating.swift
//  Let'sGo
//
//  Created by Xi Yang on 10/21/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import UIKit

/// A class that store the rating data of a user
class Rating {
    var uID: Int?
    var name: String?
    var avatar: UIImage?
    var rating: Double?
    var gender: String?
    var avgRating: Float?
    var ratedTimes: Int?
    var totalGrade: Double?
    
    // MARK: Initialization
    
    init(uID: Int, name: String, avatar: UIImage?, gender: String, rating: Double) {
        self.uID = uID
        self.name = name
        self.avatar = avatar
        self.rating = rating
        self.gender = gender
    }
}
