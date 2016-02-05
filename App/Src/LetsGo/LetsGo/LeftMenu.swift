//
//  LeftMenu.swift
//  LeftSlideoutMenu
//
//  Created by Robert Chen on 8/5/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit

/**
LeftMenu class contain the link to views of Profile, my activity, change password and sign out.
*/
class LeftMenu : UITableViewController {
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    let menuOptions = ["Profile", "My Activity", "Change Password", "Sign Out"]
}

// MARK: - UITableViewDelegate methods

extension LeftMenu {
    
    /**
     initial the content of the table view by add the link to views of Profile, my activity, change password and sign out.
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            // Both FirstViewController and SecondViewController listen for this
            NSNotificationCenter.defaultCenter().postNotificationName("openProfile", object: nil)
        case 1:
            NSNotificationCenter.defaultCenter().postNotificationName("openMyActivity", object: nil)
        case 2:
            NSNotificationCenter.defaultCenter().postNotificationName("openChangePw", object: nil)
        case 3:
            NSNotificationCenter.defaultCenter().postNotificationName("openSignout", object: nil)
        default:
            print("indexPath.row:: \(indexPath.row)")
        }
        
        // also close the menu
        NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
    }
    
}

// MARK: - UITableViewDataSource methods

extension LeftMenu {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    /**
     set the label name according to the link to views of Profile, my activity, change password and sign out.
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = menuOptions[indexPath.row]
        return cell
    }
    
}