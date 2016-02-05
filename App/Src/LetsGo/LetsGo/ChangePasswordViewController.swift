//
//  ChangePasswordViewController.swift
//  LetsGo
//
//  Created by Chen Wang on 11/28/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordViewController: UIViewController {

    let defaults = NSUserDefaults.standardUserDefaults()
    var userID: String!
    var authtoken: String!
    
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet var superView: UIView!
    
    

    // MARK: dismiss keyboard
    
    /// dismiss keyboard by clicking "return" button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == currentPassword {
            textField.resignFirstResponder()
        }
        if textField == newPassword {
            textField.resignFirstResponder()
        }
        if textField == confirmPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
    /// dismiss keyboard by clicking the background
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    // MARK: initialize view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().postNotificationName("disableScroll", object: nil)
        
        userID = defaults.stringForKey("uid")
        authtoken = defaults.stringForKey("authtoken")
        
        self.resetBtn.layer.cornerRadius = 5
        print("frame \(resetBtn.frame)")
    }

    override func viewDidAppear(animated: Bool) {
        print("frame \(resetBtn.frame)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func resetPassword(sender: AnyObject) {
        if (newPassword.text != confirmPassword.text) {
            let alertEmptyInfo = UIAlertController(
                title: "Password is not identical!",
                message: "Please check your password",
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
            presentViewController(alertEmptyInfo, animated: true, completion: nil)
            return
        }
        
        // Check password complexity
        let pwChecker = PasswordChecker()
        let pwCheckResult = pwChecker.checkTextSufficientComplexity(self.newPassword.text!)
        print (pwCheckResult)
        if !pwCheckResult.pass {
            let alertEmptyInfo = UIAlertController(
                title: "Password format error!",
                message: pwCheckResult.errmsg,
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
            presentViewController(alertEmptyInfo, animated: true, completion: nil)
            return
        }
        
        let urlString = APIURL + "/users/changepw"
        
        let parameters = ["uid": userID, "authtoken": authtoken,  "old_password": currentPassword.text!, "new_password": newPassword.text!]
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { response in
            
            if  (response.result.value != nil) {
                // print("JSON: \(json)")
                
                let result = JSON(response.result.value!)
                let status = result["status"].intValue
                
                print(status)
                if status == 201 {
                    
                    print("password reset!")
                    
                    let myAlert = UIAlertController(title: "Password Reset", message: "Reset Successfully", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ (ACTION) in
                        
                        print("segaue")
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    
                } else {
                    print("password not correct!")
                    
                    let myAlert = UIAlertController(title: "Password Reset", message: "Reset Failed", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ (ACTION) in
                    }
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                }
            }
        }
        
        
    }

}
