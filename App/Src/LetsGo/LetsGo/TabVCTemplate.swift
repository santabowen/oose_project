//
//  TabVCTemplate.swift
//  LeftSlideoutMenu
//
//  Created by Robert Chen on 8/5/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit

/**
 The content view of the right side of the container.
*/
class TabVCTemplate : UIViewController, UITabBarControllerDelegate {
    
    // placeholder for the tab's index
    var selectedTab = 0

    /**
     view did load: initial several observers
    */
    override func viewDidLoad() {
        
        // Sent from LeftMenu
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openProfileWindow", name: "openProfile", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openPreferenceWindow", name: "openPreference", object: nil)
   
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openMyactivityWindow", name: "openMyActivity", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openChangePwWindow", name: "openChangePw", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openSignoutWindow", name: "openSignout", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "disableInteraction", name: "disableRightWindowInteraction", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enableInteraction", name: "enableRightWindowInteraction", object: nil)
        
    }
    
    /**
     remove the observers when view deinit
    */
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     close the left menu
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
        view.endEditing(true)
    }
    
    /**
     when left menu was opened, disable the interaction on the content view
    */
    func disableInteraction() {
        self.view.userInteractionEnabled = false;
    }
    /**
     when left menu was closed, enable the interaction on the content view
     */
    func enableInteraction() {
        self.view.userInteractionEnabled = true;
    }
    
    /**
     link to the profile view
     */
    func openProfileWindow(){
        if tabBarController?.selectedIndex == selectedTab {
            print("profile")
            performSegueWithIdentifier("profile", sender: nil)
        }
    }
    
    /**
     link to the preference view
     */
    func openPreferenceWindow(){
        if tabBarController?.selectedIndex == selectedTab {
            performSegueWithIdentifier("preference", sender: nil)
        }
    }
    
    /**
     link to the my activity view
     */
    func openMyactivityWindow(){
//        print(tabBarController?.selectedIndex)
//        print(selectedTab)
        if tabBarController?.selectedIndex == selectedTab {
            performSegueWithIdentifier("goMyActivity", sender: nil)
        }
    }
    
    /**
     link to the change password view
     */
    func openChangePwWindow(){
        if tabBarController?.selectedIndex == selectedTab {
            print("here")
            performSegueWithIdentifier("goChangePW", sender: nil)
        }
    }
    
    /**
     link to the sign out view
     */
    func openSignoutWindow(){
        if tabBarController?.selectedIndex == selectedTab {
//            performSegueWithIdentifier("signout", sender: nil)
            print ("go login")
            let login = Login()
            login.removeDefault()
            performSegueWithIdentifier("goLogin", sender: nil)
        }
    }
}
