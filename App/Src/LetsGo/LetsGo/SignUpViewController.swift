//
//  SignUpViewController.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 11/5/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit
import MobileCoreServices

/**
 A controller class that manage the sign up view.
 */
class SignUpViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, GenderPickerViewControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var genderText: UITextField!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPWTextField: UITextField!
    @IBOutlet weak var fbSignupButton: UIButton!
    
    // for controlling moving screen
    var showKeyboard = false
    var activeTextField:UITextField?
    var moveHeight = CGFloat(0.0)
    
    // for signup function
    let login = Login()
    let defaults = NSUserDefaults.standardUserDefaults()

    // if the user has picked a image, set this variable to true
    var setPhoto = false
    
    // MARK: dismiss keyboard
    
    /// dismiss keyboard by clicking "return" button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
        }
        if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        if textField == confirmPWTextField {
            textField.resignFirstResponder()
        }
        if textField == nicknameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    /// dismiss keyboard by clicking the background
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createButton.layer.cornerRadius = 2
        self.genderButton.layer.cornerRadius = 2
        self.emailTextField.delegate = self
        self.nicknameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPWTextField.delegate = self
    }
    
    /// when the keyboard shows up, adjust the view position
    func keyboardWillShow(notification:NSNotification) {
        print("Key will show")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if let activeTextField = self.activeTextField {
                if self.view.frame.size.height - keyboardSize.height < activeTextField.frame.origin.y + activeTextField.frame.height {
                    self.moveHeight = activeTextField.frame.origin.y + activeTextField.frame.height - (self.view.frame.size.height - keyboardSize.height) + 5
                    self.view.frame.origin.y -= self.moveHeight
                }
            }
        }
    }
    
    /// when the keyboard disappear, restore the view position
    func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y += self.moveHeight
        self.moveHeight = 0.0
    }
    
    
    // MARK: viewWillDisappear
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: UITextField delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeTextField = nil
    }

    // MARK: Button function
   
    /// By clicking this button, it will show a gender picker for users to choose his/her gender
    @IBAction func genderButton(sender: UIButton) {
        let savingsInformationViewController = storyboard?.instantiateViewControllerWithIdentifier("genderPickerView") as! GenderPickerViewController
        
        savingsInformationViewController.delegate = self;
        savingsInformationViewController.genderText = genderText.text
        
        savingsInformationViewController.modalPresentationStyle = .Popover
        if let popoverController = savingsInformationViewController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
        }
        presentViewController(savingsInformationViewController, animated: true, completion: nil)
    }
    
    /// By clicking this button, a dialog will show for users to choose taking photo or choosing from existing photos
    @IBAction func changePhoto(sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "Take Photo", style: .Default, handler: { alertAction in
            // Handle Take Photo here
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Choose Existing Photo", style: .Default, handler: { alertAction in
            // Handle Choose Existing Photo
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                self.presentViewController(picker, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { alertAction in
            // Handle Cancel
        }))
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    // Signup using FB information
    @IBAction func fbSignup(sender: UIButton) {
        self.login.removeDefault()
        
        self.login.fbLogin(self) { (status) in
        
            print("after fb login in fbsignup")
            if let email = self.defaults.stringForKey("email"){
                self.emailTextField.text = email
                print(email)
            }
            
            if let name = self.defaults.stringForKey("name"){
                self.nicknameTextField.text = name
            }
            
            if let avatarUrl = self.defaults.stringForKey("avatarUrl"){
                loadImage(avatarUrl, imageView: self.profilePhoto)
            }
            
            self.passwordTextField.text = ""
            self.confirmPWTextField.text = ""
            self.fbSignupButton.hidden = true

        }
        
    }
    
    /// a image picker for user to choose photo from photo library.
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        self.setPhoto = true
        profilePhoto.image = image
        setProfileImageShape(profilePhoto)
    }

    
    // MARK: create account
    
    /**
     Create an account. Send user's data to the server.
     */
    @IBAction func createButton(sender: UIButton) {
        print("create account")
    
        if self.defaults.stringForKey("fbToken") != nil {
            print("got fb token")
        } else {
            if emailTextField.text == "" || passwordTextField.text == "" {
                // Add an alter message to tell the user of this login failure
                let alertEmptyInfo = UIAlertController(
                    title: "Signup Failed!",
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

            // password and confirm password must be the same

            if self.passwordTextField.text != self.confirmPWTextField.text {
                // Add an alter message to tell the user of this login failure
                let alertEmptyInfo = UIAlertController(
                    title: "Password must be the same!",
                    message: "Please check your password.",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                // Add a "OK" button on the alter subview
                alertEmptyInfo.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default)
                    { (action: UIAlertAction) -> Void in
                        // do nothing
                        self.passwordTextField.text = ""
                        self.confirmPWTextField.text = ""
                    }
                )
                // Present the alter message on the view.
                presentViewController(alertEmptyInfo, animated: true, completion: nil)
                return
            }
            
            if self.confirmPWTextField.text != "" {
                print ("check pw")
                // Check password complexity
                let pwChecker = PasswordChecker()
                let pwCheckResult = pwChecker.checkTextSufficientComplexity(self.passwordTextField.text!)
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
            }
        }
        
        // parameters
        var mode = ""
        var fbToken = ""
        var avatarUrl = ""
        var password = ""

        
        if self.passwordTextField.text == self.confirmPWTextField.text &&
            self.confirmPWTextField.text != "" {
            mode = "email"
            print ("check pw")
            // Check password complexity
            let pwChecker = PasswordChecker()
            let pwCheckResult = pwChecker.checkTextSufficientComplexity(self.passwordTextField.text!)
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
                return
            }
                
        } else {
            if let token = defaults.stringForKey("fbToken"){
                fbToken = token
                mode = "fb"
            } 
        }
        
        if let avatar = defaults.stringForKey("avatarUrl"){
            avatarUrl = avatar
        }
        
        if setPhoto {

            self.profilePhoto.image = UIImage(data: (self.profilePhoto.image?.lowestQualityJPEGNSData)!, scale:1.0)
            self.profilePhoto.image = resizeImage(self.profilePhoto.image!, newWidth: 150)
            
            
            let s3 = S3Uploader()
            let emailText = self.emailTextField.text!.stringByReplacingOccurrencesOfString("@", withString: "_")
            avatarUrl = "\(emailText)-avatar.png"
            avatarUrl = s3.uploadToS3(self.profilePhoto, imgName: avatarUrl)
        }
        
        if let pw = self.passwordTextField.text {
            password = pw
        }
        
        self.login.signupByEmail(self.emailTextField.text!,
                                 password: password,
                                 name: self.nicknameTextField.text!,
                                 gender: self.genderText.text!,
                                 avatarUrl: avatarUrl,
                                 fbToken: fbToken,
                                 mode: mode) { (status, errMsg) in
        
            if status == 200 {
                let signupSuccess = UIAlertController(
                    title: "Signup Success!",
                    message: "Please login use your account and password.",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                // Add a "OK" button on the alter subview
                signupSuccess.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default)
                    { (action: UIAlertAction) -> Void in
                        self.performSegueWithIdentifier("toLoginView", sender: nil)
                    }
                )
                self.presentViewController(signupSuccess, animated: true, completion: nil)
            } else {
                print ("signup failed")
                let signupSuccess = UIAlertController(
                    // TODO: error message ?
                    title: "Signup failed!",
                    message: errMsg,
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                // Add a "OK" button on the alter subview
                signupSuccess.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default)
                    { (action: UIAlertAction) -> Void in
                        // do nothing
                    }
                )
                self.presentViewController(signupSuccess, animated: true, completion: nil)
                
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toGender" {
            let popoverViewController = segue.destinationViewController 
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    /// Set the text of the Gender text field according to the data getting from the popover view.
    func saveText(strText: NSString) {
        self.genderText.text=strText as String
    }
}


