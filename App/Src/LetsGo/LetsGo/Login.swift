//
//  Login.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 11/8/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire


/**
 Deal with login related functions.
 */
class Login {
    
    // get NSUserDefaults for storing use's info
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    /** 
     Login by email
     -parameter email: the user's email
     -parameter password: the user's password
     */
    func login(email: String, password: String, complete: (status: Int) -> Void)  {
        self.removeDefault()
        
        let parameters = ["email": email, "password": password]

        Alamofire.request(.POST,"\(APIURL)/users/signin", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    // parse result
                    let result = self.parseLoginJSON(JSON(response.result.value!))

                    // if login success, store user's info to defaults
                    if result.status == 200 {
                        defaults.setValue(result.uid, forKey: "uid")
                        defaults.setObject(email, forKey: "email")
                        defaults.setObject(result.name, forKey: "name")
                        defaults.setObject(result.authtoken, forKey: "authtoken")
                        defaults.setObject(result.avatarUrl, forKey: "avatarUrl")
                        defaults.synchronize()
                    } else {
                        debugPrint(response)
                    }

                    defaults.setValue(result.status, forKey: "loginStatus")
                    complete(status: result.status)
                }
        }
    }
    
    /**
     After login using FB login API, send FB info to server and get uid, name, authtoken from server.
     -parameter fbToken: the facebook login token
     -parameter name: the username
     -parameter email: the user's email
     -parameter gender: the user's gender
     -parameter avatarUrl: the user's profile photo link
     */
    func authFB(fbToken: String, name: String, email: String, gender: String, avatarUrl: String, complete: (status: Int) -> Void)  {
        
        let parameters = ["fbToken": fbToken, "name": name, "email": email, "gender": gender, "avatarUrl": avatarUrl]
        
        Alamofire.request(.POST,"\(APIURL)/users/fblogin", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    let defaults = NSUserDefaults.standardUserDefaults()
                    debugPrint(response)
                    
                    // parse result
                    let result = self.parseLoginJSON(JSON(response.result.value!))
                    
                    // if login success, store user's info to defaults
                    if result.status == 200 {
                        defaults.setValue(result.uid, forKey: "uid")
                        defaults.setObject(email, forKey: "email")
                        defaults.setObject(result.name, forKey: "name")
                        defaults.setObject(result.authtoken, forKey: "authtoken")
                        defaults.setObject(result.avatarUrl, forKey: "avatarUrl")
                        defaults.synchronize()
                    } else {
//                        print("auth FB failed...")
                    }
                    
                    defaults.setValue(result.status, forKey: "loginStatus")
                    complete(status: result.status)
                }
        }
    }
    
    
    /// Remove user's data from userdefault.
    func removeDefault(){
        FBSDKLoginManager().logOut()
        self.defaults.removeObjectForKey("uid")
        self.defaults.removeObjectForKey("name")
        self.defaults.removeObjectForKey("authtoken")
        self.defaults.removeObjectForKey("loginStatus")
        self.defaults.removeObjectForKey("email")
        self.defaults.removeObjectForKey("avatarUrl")
        self.defaults.removeObjectForKey("fbToken")
        self.defaults.removeObjectForKey("nickname") // FIXME: nickname is change to name
    }
    
    /// Parse json data, get uid, name, avatarUrl and authtoken.
    func parseLoginJSON(json: JSON) -> (status: Int, uid: Int, name: String, avatarUrl: String, authtoken: String, errMsg:String?){
        let status = json["status"].intValue
        let uid = json["uid"].intValue
        let avatarUrl = json["avatarUrl"].stringValue
        let authtoken = json["authtoken"].stringValue
        let name = json["name"].stringValue
        var errMsg:String?
        if json["errormsg"] != nil {
            errMsg = json["errormsg"].stringValue
        }
        return (status, uid, name, avatarUrl, authtoken, errMsg)
    }
    
    
    // login by facebook, send data to backend server and get user's information back.
    func getUserInfoByFB(fbUserID: String, email: String, avatarUrl: String, friendList: [String]) -> Bool{
        // Send data to backend server
        // if the facebook account didn't signup before, what will the server reply
        
        self.defaults.setObject(fbUserID, forKey: "fbUserID")
        self.defaults.setObject(email, forKey: "email")
        self.defaults.setObject(avatarUrl, forKey: "avatarUrl")
        
        return true
    }
    
    
    // perform facebook login API, and if success, go to next view
    func fbLogin(fromViewController: UIViewController, complete: (status: Int) -> Void) {
        removeDefault()
        
        let facebooklogin = FBSDKLoginManager()
        let facebookReadPermissions = ["public_profile", "email", "user_friends"]
        
        facebooklogin.logInWithReadPermissions(facebookReadPermissions, fromViewController:fromViewController,
            handler: { (result:FBSDKLoginManagerLoginResult!, facebookError:NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    if facebookError != nil {
                        FBSDKLoginManager().logOut()
                        complete(status: 401)
                        
                    } else if result.isCancelled {
                        // Handle cancellations
                        FBSDKLoginManager().logOut()
                        
                    } else {
                        // If you ask for multiple permissions at once, you
                        // should check if specific permissions missing
                        defaults.setObject(result.token.tokenString, forKey: "fbToken")
                        defaults.synchronize()
                        
                        getUserFBInfo() {(status) in
                            var allPermsGranted = true
                            
                            //result.grantedPermissions returns an array of _NSCFString pointers
                            let grantedPermissions = Array(result.grantedPermissions).map( {"\($0)"} )
                            for permission in facebookReadPermissions {
                                if !grantedPermissions.contains(permission) {
                                    allPermsGranted = false
                                    break
                                }
                            }
                            
                            if allPermsGranted {
                                // Do work
                            } else {
                                //The user did not grant all permissions requested
                                //Discover which permissions are granted
                                //and if you can live without the declined ones
                            }
                            
                            complete(status: 200)
                        }
                    }
                }
        })
    }
    
    
    /** 
     Signup by email. 
     -parameter email: the user's email
     -parameter password: the user's password 
     -parameter name: the user's name
     -parameter gender: the user's gender (optional)
     -parameter avatarUrl: the user's profile photo link
     -parameter fbToken: the user's facebook token
     -parameter mode: use email or facebook information to sign up.
     */
    func signupByEmail(email: String, password: String, name: String, gender: String, avatarUrl: String, fbToken: String, mode: String, complete: (status: Int, errMsg: String?) -> Void) {
                
        let parameters = [
            "name": name,
            "email": email,
            "password": password,
            "gender": gender,
            "fbToken": fbToken,
            "avatarUrl": avatarUrl,
            "mode": mode
        ]
        
        print("email \(email)")
        print("pw \(password)")
        print("name \(name)")
        print("gender \(gender)")
        print("avatarUrl \(avatarUrl)")
        print("fbtoken \(fbToken)")
        print("mode \(mode)")
        
        Alamofire.request(.POST,"\(APIURL)/users", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                
                let defaults = NSUserDefaults.standardUserDefaults()
                

                if response.result.error == nil {
                    
                    let result = self.parseLoginJSON(JSON(response.result.value!))

                    // if login success, store user's info to defaults
                    print("signup \(result)")
                    print("status \(result.status)")
                    
                    if result.status == 200 {
                        self.defaults.setObject(email, forKey: "email")
                        self.defaults.setObject(name, forKey: "name")
                        self.defaults.setObject(gender, forKey: "gender")
                        self.defaults.setObject(avatarUrl, forKey: "avatarUrl")
                        self.defaults.synchronize()
                        defaults.synchronize()
                    } else {
                        print("Signup failed...")
                        debugPrint(response)
                    }
                    defaults.setValue(result.status, forKey: "loginStatus")
                    complete(status: result.status, errMsg: (result.errMsg)!)
                } else {
                    print("Signup failed...")
                    debugPrint(response)
                }
        }
    }
    
}
