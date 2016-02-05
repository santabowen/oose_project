//
//  ResetPasswordViewController.swift
//  LetsGo
//
//  Created by Xi Yang on 11/26/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit
import Alamofire

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var resetButtonUI: UIButton!
    @IBOutlet weak var sendButtonUI: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var validationCode: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the shape of the buttons
        self.resetButtonUI.layer.cornerRadius = 5
        self.sendButtonUI.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: dismiss keyboard
    /// dismiss keyboard by clicking "return" button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == email {
            textField.resignFirstResponder()
        }
        if textField == validationCode {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func sendValidationCodeToEmail(sender: AnyObject) {
        
        if (email.text == nil) {
            let alertEmptyInfo = UIAlertController(
                title: "Email cannot be empty!",
                message: "Please enter your email address.",
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
            self.presentViewController(alertEmptyInfo, animated: true, completion: nil)
            return
        }
        
        let urlString = APIURL + "/users/forgetpw"
        
        Alamofire.request(.POST, urlString, parameters: ["email":self.email.text!], encoding: .JSON).responseJSON { response in
            
            if  (response.result.value != nil) {
                
                let result = JSON(response.result.value!)
                let status = result["status"].intValue
                
                if status == 201 {
                    let alertEmptyInfo = UIAlertController(
                        title: "Validation Code sent!",
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
                    self.presentViewController(alertEmptyInfo, animated: true, completion: nil)
                    
                } else {
                    let alertEmptyInfo = UIAlertController(
                        title: "Email not correct!",
                        message: "Please check your email address.",
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
                    self.presentViewController(alertEmptyInfo, animated: true, completion: nil)

                }
            } else {
                // print error
                print("Forget password error ------------------------------")
                debugPrint(response)
            }
        }
    }
    
    @IBAction func resetPassword(sender: AnyObject) {

        if (newPassword.text != confirmPassword.text) {
            self.newPassword.text = nil
            self.confirmPassword.text = nil
            let alertEmptyInfo = UIAlertController(
                title: "Password must be identical!",
                message: "Please enter your new password again.",
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
        
        if self.validationCode.text == nil || self.validationCode.text == "" {
            let alertEmptyInfo = UIAlertController(
                title: "Validation code error!",
                message: "Please check your validation code.",
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
        
        let urlString = APIURL + "/users/resetpw"
        
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
        
        
        Alamofire.request(.POST, urlString, parameters: ["email":self.email.text!, "validation_code":self.validationCode.text!, "new_password": self.newPassword.text!], encoding: .JSON).responseJSON { response in
            
            if  (response.result.value != nil) {
                //                print("JSON: \(json)")
                
                let result = JSON(response.result.value!)
                let status = result["status"].intValue
                
                if status == 201 {
                    let alertSuccess = UIAlertController(
                        title: "Password reset succeed!",
                        message: "Use your new password to login.",
                        preferredStyle: UIAlertControllerStyle.Alert
                    )
                    // Add a "OK" button on the alter subview
                    alertSuccess.addAction(UIAlertAction(
                        title: "OK",
                        style: .Default)
                        { (action: UIAlertAction) -> Void in
                            print("goLogin")
                            self.performSegueWithIdentifier("goLogin", sender: nil)   
                        }
                    )
                    self.presentViewController(alertSuccess, animated: true, completion: nil)
                    return
                } else {
                    let alertFail = UIAlertController(
                        title: "Password reset failed!",
                        message: "Please reset again.",
                        preferredStyle: UIAlertControllerStyle.Alert
                    )
                    // Add a "OK" button on the alter subview
                    alertFail.addAction(UIAlertAction(
                        title: "OK",
                        style: .Default)
                        { (action: UIAlertAction) -> Void in
                            
                        }
                    )
                    self.presentViewController(alertFail, animated: true, completion: nil)
                    return
                }
            }
        }
    }
}
