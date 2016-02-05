//
//  User.swift
//  Let'sGo
//
//  Created by Xi Yang on 10/15/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import Foundation
import Alamofire


enum GENDER {
    case MALE
    case FEMALE
}

class User {
//    var uId: Int?
    var _uid : Int!
    var nickName: String!
    var rating: Rating?
    var avatar: String?
    var email: String!
    var address: String!
    var password: String?
    var gender: GENDER?
    var selfDescription: String!
    var preference: Preference?
    var myActivityList: MyActivityList?
    var nearbyActivityList: NearbyActivityList?
    var uid : Int{
        return self._uid
    }
    
    init(){
        self._uid = -1
        self.avatar = nil
        self.nickName = "Char Name"
        self.address = "Neverwinter"
        self.email = "CharName@NW.com"
        self.selfDescription = "All stats 20."
    }

    
    init(uid: Int, avatarStr: String){
        self._uid = uid
        self.avatar = avatarStr
        self.nickName = "Char Name"
        self.address = "Neverwinter"
        self.email = "CharName@NW.com"
        self.selfDescription = "All stats 20."
    }
    
    
    /// parseJson content for user 
    func parseJson(json: JSON) {
        
        if let result = json as JSON?{
            self._uid = result["uid"].intValue
            self.avatar = result["avatar"].stringValue
            self.nickName = result["name"].stringValue
            self.address = result["address"].stringValue
            self.email = result["email"].stringValue
            self.rating = Rating(uID: _uid, name: nickName, avatar: nil, gender: "", rating: result["rating"].doubleValue)
            self.selfDescription = result["self_description"].stringValue
            print("init star =\(result["rating"].doubleValue) ")
        }
    }

    
    func downloadUserInfo(uid: String, token: String, viewUid: String, completed: DownloadComplete) {
        
        let parameters = ["uid": uid, "authtoken": token, "viewUid": viewUid]

        Alamofire.request(.GET, "\(APIURL)/users/getprofile", parameters: parameters)
            .responseJSON { response in
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.parseJson( JSON(response.result.value!)["profile"])
                    completed()
                    
                }
                
        }  
    
    }
    
    
    func refresh (uid: String, token: String, complete: (status: Int) -> Void) {
        
        
        
    }

}