//
//  ActivityCell.swift
//  Let'sGo
//
//  Created by Chen Wang on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import UIKit
import Alamofire

class ActivityCell: UITableViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var activityType: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var groupNum: UILabel!
    @IBOutlet weak var activityTypeImage: UIImageView!
    
    var actId: Int!
    var isFinished: Bool?
    var memberNum: Int?
    
    var request: Alamofire.Request?

    
    /// the function to do the initialization first after this view appear
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    ///  draw the corner radius for each activity cell.
    override func drawRect(rect: CGRect) {
        avatarImg.layer.cornerRadius = avatarImg.frame.size.width / 2
    }
    
    /// This function sets the content of each table view cell
    /// - parameter activity: (Activity) see in the model group. A self-defined class for each activity
    func updateCell(activity: Activity, img: UIImage?) {
    
        if activity.avatarUrl != nil &&  activity.avatarUrl != ""{
            if img != nil {
                self.avatarImg.image = img
                setProfileImageShapeSmall(self.avatarImg)
            } else {
                request = Alamofire.request(.GET, activity.avatarUrl!).validate(contentType: ["image/*"]).response(completionHandler: { (request, response, data, err) in
                    if err == nil {
                        if data != nil {
                            let img = UIImage(data: data!)
                            self.avatarImg.image = img
                            setProfileImageShapeSmall(self.avatarImg)
                            MainActivityViewController.avatarCache.setObject(img!, forKey: activity.avatarUrl!)
                        }
                    }
                })
            }
        } else if activity.avatarUrl! == "" {
            self.avatarImg.image  = UIImage(named: "default-avatar.png")
        }
        
        activityType.text = activity.activityType
        location.text = activity.location
        time.text = activity.time
        groupNum.text = "\(activity.memberNumber)/\(activity.groupSize)"
        actId = activity.activityId
        isFinished = activity.isFinished
        memberNum = activity.memberNumber

    }
}
