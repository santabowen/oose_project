//
//  LoginModel.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 11/8/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import Foundation
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit


/**
 Deal with login related functions.
 */
class Login : UIViewController {
    //API base url
//    let APIUrl = "https://morning-brook-7884.herokuapp.com"
    let APIUrl = "http://localhost:3000"
    
    // get NSUserDefaults for storing use's info
    let defaults = NSUserDefaults.standardUserDefaults()
    

    // login by email
    func login(email: String, password: String) -> (status: Int, authtoken: String) {
        print("login------------------")
        
        var uid: Int?
        var nickname: String?
        var token: String?
        
        let parameters = ["email": email, "password": password]
        
        Alamofire.request(.POST,"\(APIUrl)/users/signin", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                let defautls = NSUserDefaults.standardUserDefaults()
                
                // store user's info to defaults
//                self.defaults.setObject(uid, forKey: "uid")
//                self.defaults.setObject(email, forKey: "email")
//                self.defaults.setObject(nickname, forKey: "nickname")
//                self.defaults.setObject(token, forKey: "token")
//                self.defaults.synchronize()
                
                debugPrint(response)
                print("Response String: \(response.result.value)")

        }
        

        
        return (1, "abc")
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
    func fbLogin(fromViewController: UIViewController) {
        // clean userDefault
        
        let facebooklogin = FBSDKLoginManager()
        let facebookReadPermissions = ["public_profile", "email", "user_friends"]
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            //For debugging, when we want to ensure that facebook login always happens
            FBSDKLoginManager().logOut()
            //Otherwise do:
            print("already login FB")
            return
        }
        
        facebooklogin.logInWithReadPermissions(facebookReadPermissions, fromViewController:fromViewController,
            handler: { (result:FBSDKLoginManagerLoginResult!, facebookError:NSError!) -> Void in
                
                let defaults = NSUserDefaults.standardUserDefaults()
                
                if facebookError != nil {
                    FBSDKLoginManager().logOut()
                    
                } else if result.isCancelled {
                    // Handle cancellations
                    FBSDKLoginManager().logOut()
                    
                } else {
                    // If you ask for multiple permissions at once, you
                    // should check if specific permissions missing
                    defaults.setObject(result.token.tokenString, forKey: "fbToken")
                    
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
                        //                        let fbToken = result.token.tokenString
                        //                        let fbUserID = result.token.userID
                        
                        print(result.token.userID)
                        
                    } else {
                        //The user did not grant all permissions requested
                        //Discover which permissions are granted
                        //and if you can live without the declined ones
                    }
                    
                    // get the user's info and friend list
                    getUserFBInfo()
                    getUserFriends()
                }
        })
    }
    
    
    // signup by email
    func signupByEmail(email: String, password: String, nickname: String, gender: String, avatarUrl: String, fbToken: String) -> (status: Int, authtoken: String) {
        //        let opt = try HTTP.POST(urlString+"/users", parameters: ["name": nickname, "email": email, "password": password])
        print("sing up")
        print("email: \(email)")
        print("password: \(password)")
        print("nickname: \(nickname)")
        print("gender: \(gender)")
        print("avatarUrl: \(avatarUrl)")
        print("fbToken: \(fbToken)")
        let parameters = [
            "name": nickname,
            "email": email,
            "password": password,
            "gender": gender,
            "fbToken": fbToken
        ]
        
        Alamofire.request(.POST,"\(APIUrl)/users", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                debugPrint(response)
                print("Response String: \(response.result.value)")
        }
        
        
        
        let result = true
        if result {
            self.defaults.setObject(email, forKey: "email")
            self.defaults.setObject(nickname, forKey: "nickname")
            self.defaults.setObject(gender, forKey: "gender")
            self.defaults.setObject(avatarUrl, forKey: "avatarUrl")
            self.defaults.synchronize()
        }
        
        return (201, "abc")
    }
    
    
    // reset password
    func resetPassword(email: String) -> Int {
        print("reset email: \(email)")
        return 1
    }
    
    /**
     Clean userDefault before login and signup
     */
    func cleanUserDefaults(){
        print("clean user default")
        FBSDKLoginManager().logOut()
////        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
////            NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
////        }
//        defaults.removeObjectForKey("fbUserID")
//        defaults.removeObjectForKey("email")
//        defaults.removeObjectForKey("fbToken")
//        defaults.removeObjectForKey("gender")
//        defaults.removeObjectForKey("nickname")
//        defaults.removeObjectForKey("uid")
//        defaults.removeObjectForKey("facebookProfileUrl")
//        defaults.removeObjectForKey("userId")
//        defaults.removeObjectForKey("avatarUrl")
//        
//
//        print(defaults.dictionaryRepresentation())
    }

    
}
