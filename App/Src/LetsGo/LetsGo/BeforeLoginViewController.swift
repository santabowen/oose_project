//
//  BeforeLoginViewController.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 11/7/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

/**
 This class check whether the user is login or not. If the user is not login, direct the user to the login view; otherwise, direct the user to the main activity view.
 */
class BeforeLoginViewController: UIViewController {
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // Load the view and check whether the user is logged in.
        if let _ = defaults.stringForKey("authtoken"){
            print("logged in...go Main activity")
            self.performSegueWithIdentifier("directToMainActivity", sender: nil)
        } else {

            let login = Login()
            login.removeDefault()
            self.performSegueWithIdentifier("toLogin", sender: nil)
        }
    }
}
