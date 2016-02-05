//
//  EditViewController.swift
//  LetsGo
//
//  Created by Chen Wang on 11/25/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit
import Alamofire

class EditViewController: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var editboxField: UITextField!
    
    var item: Int!
    
    var user: User?
    
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var userID: String!
    var authtoken: String!
    
    /// click pressed btn
    @IBAction func backBtnPressed(sender: AnyObject) {
        
    
        if let inputValue = editboxField.text! as String? {
            var parameters: [String:String]?
            if item == 1 {
                parameters = [
                    "uid": userID,
                    "authtoken": authtoken,
                    "type": "name",
                    "name": inputValue
                ]

            } else if item == 2 {
                parameters = [
                    "uid": userID,
                    "authtoken": authtoken,
                    "type": "address",
                    "address": inputValue
                ]
            } else if item == 5 {
                
                parameters = [
                    "uid": userID,
                    "authtoken": authtoken,
                    "type": "self_description",
                    "self_description": inputValue
                ]
            }
            
            print(parameters)
            
            let urlString = APIURL + "/users/updateprofile"
            Alamofire.request(.POST, urlString, parameters: parameters)
        
        }
    
        
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().postNotificationName("disableScroll", object: nil)
        
        userID = defaults.stringForKey("uid")
        authtoken = defaults.stringForKey("authtoken")
        
        switch item {
        case 1:
            titleLbl.text = "Please type in your new name"
            editboxField.text = (user?.nickName)!
        case 2:
            titleLbl.text = "Please type in your address"
            editboxField.text = (user?.address)!
        case 5:
            titleLbl.text = "hi, what's up"
            editboxField.text = (user?.selfDescription)!
        default:
            print("nothing to edit ")
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        editboxField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
