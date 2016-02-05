//
//  FBInfo.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 10/25/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import Foundation
import FBSDKCoreKit


/**
 Get a user's Facebook information and store it in userDefault.
 The user should login via Facebook login API before this function
 is called.
 */
func getUserFBInfo(complete: (status: Int) -> Void) {
    let fbRequest1 = FBSDKGraphRequest(graphPath:"/me", parameters: ["fields":"email,name"], HTTPMethod: "GET")
    
    fbRequest1.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            if error == nil {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                
                print("My information are : \(result)")
                
                // Get user's id and profile photo link, and save them to userDefault
                if let fbUserID = result["id"]{
                    let avatarUrl = "https://graph.facebook.com/\(fbUserID!)/picture?type=large"
                    print(avatarUrl)
                    defaults.setObject(fbUserID!, forKey: "fbUserID")
                    defaults.setObject(avatarUrl, forKey: "avatarUrl")
                }
                
                // Get user's name and save it to userDefault
                if let name = result["name"] {
                    print(name!)
                    defaults.setObject(name!, forKey: "name")
                }
                
                if let email = result["email"] {
                    print(email!)
                    defaults.setObject(email!, forKey: "email")
                }
                
                defaults.synchronize()
                
            } else {
                print("Error Getting personal information \(error)")
            }
            complete(status: 1)
        }
    }
}


/**
 Get a user's Facebook friends and store it in userDefault (not decided yet).
 The user should login via Facebook login API before this function is called.
 */
func getUserFriends() {
    
    let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: ["fields":"email,name"], HTTPMethod: "GET")
    fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
        
        if error == nil {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            print("Friends are : \(result)")
            if let friendobjects = result.valueForKey("data") as? [NSDictionary]{
                for friendobj in friendobjects{
                    if let friendName = friendobj["name"]{
                        print(friendName)
                    }
                    if let friendEmail = friendobj["email"]{
                        print(friendEmail)
                    }
                }
            }
            
            defaults.synchronize()
            
        } else {
            print("Error Getting Friends \(error)")
        }
    }
}

