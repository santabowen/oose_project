//
//  LoginViewController.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 10/25/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

/**
 Deal with login tasks, including Facebook login API.
 */
class LoginViewController: UIViewController, UITextFieldDelegate
{
    let defaults = NSUserDefaults.standardUserDefaults()
    // for login and signup
    let login = Login()
    
    // User's email input
    @IBOutlet weak var emailTextField: UITextField!{
        didSet {
            emailTextField.delegate = self
        }
    }
    
    // User's password input
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet {
            passwordTextField.delegate = self
        }
    }

    /// dismiss keyboard by clicking "return" button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
        }
        if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    /// dismiss keyboard by clicking the background
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    override func viewDidLoad() {
        login.removeDefault()
    }
    
    /**
     Login via email.
     - parameter sender (UIButton): the login button.
     */
    @IBAction func loginViaEmail(sender: UIButton) {
        login.removeDefault()
        
        // The email and password cannot be empty.
        if emailTextField.text == "" || passwordTextField.text == "" {
            // Add an alter message to tell the user of this login failure
            let alertEmptyInfo = UIAlertController(
                title: "Login Failed!",
                message: "Email and password cannot be empty.",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            // Add a "OK" button on the alter subview
            alertEmptyInfo.addAction(UIAlertAction(
                title: "OK",
                style: .Default)
                { (action: UIAlertAction) -> Void in
                    // do nothing
                }
            )
            // Present the alter message on the view.
            presentViewController(alertEmptyInfo, animated: true, completion: nil)
            return
        }
        
        // check email format
        if !emailTextField.text!.containsString("@") {
            // Add an alter message to tell the user of this login failure
            let alertEmptyInfo = UIAlertController(
                title: "Email error!",
                message: "Please check your email.",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            // Add a "OK" button on the alter subview
            alertEmptyInfo.addAction(UIAlertAction(
                title: "OK",
                style: .Default)
                { (action: UIAlertAction) -> Void in
                    // do nothing
                }
            )
            // Present the alter message on the view.
            presentViewController(alertEmptyInfo, animated: true, completion: nil)
            return
        }
        
        // call login function and get login result
        self.login.login(emailTextField.text!, password: passwordTextField.text!) { (status) in

            if status == 200 {
                self.performSegueWithIdentifier("toMainActivity", sender: nil)
            } else {
                // Add an alter message to tell the user of this login failure
                let alertLoginFail = UIAlertController(
                    title: "Login Failed!",
                    message: "Please check your Email and password!",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                // Add a "OK" button on the alter subview
                alertLoginFail.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default)
                    { (action: UIAlertAction) -> Void in
                        // do nothing
                    }
                )
                // Present the alter message on the view.
                self.presentViewController(alertLoginFail, animated: true, completion: nil)
            }
        }
    }
    
    
    /**
     Login via Facebook API.
     - parameter sender (UIButton): the facebook login button.
    */
    @IBAction func fbLogin(sender: UIButton) {
        login.removeDefault()
        
        let facebooklogin = FBSDKLoginManager()
        let facebookReadPermissions = ["public_profile", "email", "user_friends"]
        
        facebooklogin.logInWithReadPermissions(facebookReadPermissions, fromViewController:self,
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
                    defaults.synchronize()
                    
                    
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
                    
                    // get the user's info and friend list
                    getUserFBInfo() {(status) in
                        var loginData = true

                        // TODO: check fbUserID is needed?
                        var fbUserID: String?
                        var fbToken: String?
                        var email: String?
                        var name: String?
                        var avatarUrl = ""
                        
                        if self.defaults.stringForKey("fbUserID") != nil {
                            fbUserID = self.defaults.stringForKey("fbUserID")
                        } else {
                            loginData = false
                        }
                        
                        if self.defaults.stringForKey("fbToken") != nil {
                            fbToken = self.defaults.stringForKey("fbToken")!
                        } else {
                            loginData = false
                        }
                        
                        if self.defaults.stringForKey("email") != nil {
                            email = self.defaults.stringForKey("email")!
                        } else {
                            loginData = false
                        }
                        
                        if self.defaults.stringForKey("avatarUrl") != nil {
                            avatarUrl = self.defaults.stringForKey("avatarUrl")!
                        }
                        
                        if self.defaults.stringForKey("name") != nil {
                            name = self.defaults.stringForKey("name")!
                        }
                        
                        if loginData {
                            self.login.authFB(fbToken!, name: name!, email: email!, gender: "", avatarUrl: avatarUrl) { (status) in
                                if status == 200 {
                                    self.performSegueWithIdentifier("toMainActivity", sender: nil)
                                } else {
                                    self.login.removeDefault()
                                }
                                
                            }
                        }
                    }
                }
        })
    }
}