//
//  Activity.swift
//  Let'sGo
//
//  Created by Xi Yang on 10/21/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import Foundation
import Alamofire

enum ACTIVITYTYPE: String {
    case BASKETBALL = "Basketball"
    case BADMINITON = "Badminton"
    case JOGGING = "Jogging"
    case GYM = "Gym"
    case TENNIS = "Tennis"
}

class Activity {
    
    private var _activityId: Int
    private var _activityType: String
    private var _location: String
    private var _geoInfo = [Double?](count : 2, repeatedValue : nil)
    private var _time: String
    private var _duration: Int?
    private var _hostID: Int
    private var _hostAvatar: String?
    private var _groupSize: Int
    private var _durationStr: String?
    private var _isFinished: Bool?
    private var isVisibleToFriends: Bool?
    private var isVisibleToNearby: Bool?
    private var _members: [User]?
    private var _memberNum: Int
    private var _avatarUrl: String? // the avatar url for the host
    private var _setActivityType = false

    
    var activityId: Int {
        return _activityId
    }
    
    var duration: String?{
        return _durationStr
    }
    
    var hostID: Int {
        return _hostID
    }
    
    var hostAvatar: String? {
        return _hostAvatar
    }
    
    var activityType: String {
        return _activityType
    }
    
    func setActivityType(type:String){
        if _setActivityType == false {
            _activityType = type
            _setActivityType = true
        }
    }
    
    var members: [User]? {
        return _members
    }
    
    var geoInfo : [Double?]{
        return _geoInfo
    }
    
    var location: String {
        return _location
    }
    
    var time: String {
        return _time
    }
    
    var groupSize: Int {
        return _groupSize
    }
    
    var memberNumber: Int {
        return _memberNum
    }
    
    var avatarUrl: String? {
        return _avatarUrl
    }
    
    var isFinished: Bool? {
        return _isFinished
    }
    
    /// This function sends the activity information to server.
    class func sendActivity(urlString: String?, parameterDict: [String:NSObject], complete:(status: Int) -> Void){
        if urlString == nil{
            print("Send Activity failed: empty URL String.")
        }
        else{
            Alamofire.request(.POST, urlString!, parameters: parameterDict,
                encoding: .JSON).responseJSON { response in
                    debugPrint(response)
                    let status = JSON(response.result.value!)["status"].intValue
                    complete(status:status)
            }
        }
    }
    /// The default initializer for an activity.
    init(activityId: Int, activityType: String, hostID: Int, hostAvatar: String, location: String, time: String, groupSize: Int, geoInfo : [Double?], members:[User]){
        self._activityId = activityId
        self._activityType = activityType
        self._location = location
        self._time = time
        self._groupSize = groupSize
        self._memberNum = 0
        self._geoInfo = geoInfo
        self._members = members
        self._hostID = hostID
        self._hostAvatar = hostAvatar
    }
    
    /// The initializer for an activity using JSON string.
    init(result: JSON){
        self._activityId = result["actid"].intValue
        self._activityType = result["actType"].stringValue
        self._groupSize = result["groupSize"].intValue
        self._memberNum = result["currentNum"].intValue
        self._location = result["location"].stringValue
        self._hostID = result["hostid"].intValue
        self._hostAvatar = result["hostavatar"].stringValue
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let startDate = dateFormatter.dateFromString(result["startTime"].stringValue)

        self._time = startDate!.toDateMediumString() as! String
        self._duration = result["duration"].intValue
        self._durationStr = NSDate.durationStrFromInt(_duration!) as? String
        let memberlist = result["memberlist"].array
        if memberlist == nil{
            self._members = nil
        }
        else{
            self._members = [User]()
            for memberStr in memberlist!{
                let uid = memberStr["uid"].intValue
                let avatar = memberStr["avatar"].stringValue
                self._members?.append(User(uid: uid, avatarStr: avatar))
            }
        }
        self._geoInfo = [result["lat"].doubleValue, result["lng"].doubleValue]
        self._avatarUrl = result["avatar"].stringValue
        if result["is_expired"] != nil {
            self._isFinished = result["is_expired"].boolValue
            if self._isFinished == true {
               self.setActivityType(self.activityType + " (end)")
            }
        }
    }
}