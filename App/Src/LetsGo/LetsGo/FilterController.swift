//
//  FilterController.swift
//  LetsGo
//
//  Created by lv huizhan on 11/27/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import Foundation
import Alamofire

class FilterController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    // The string values of activity names.
    var activityTypeArr = ["Basketball", "Badminton", "Tennis", "Jogging", "Gym"]
    // Dictionary in the form of [activity:selected].
    var filterDict:[String:Bool!]!

    @IBOutlet weak var filterTableView: UITableView!
    
    override func viewDidLoad(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("disableScroll", object: nil)

        // Initialize the activity table.
        self.tabBarController?.tabBar.hidden = true
        filterTableView.dataSource = self
        filterTableView.delegate = self
        filterTableView.registerClass(ActivityTypeCell.self, forCellReuseIdentifier: "ActivityTypeCell")
        self.filterTableView.reloadData()
        
        // Get local filter value, if failed then use default.
        let defaults = NSUserDefaults.standardUserDefaults()
        filterDict = defaults.dictionaryForKey("filterDict") as? [String:Bool]
        if filterDict == nil{
            print("Initializing filter to all true values.")
            filterDict = [String:Bool!]()
            for activity in activityTypeArr{
                filterDict![activity] = true
            }
        }
        else{ print("Initializing using user default values.") }

        // Setting the styles for the tableview.
        filterTableView.tableFooterView = UIView(frame: CGRect.zero)
        filterTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.navigationItem.hidesBackButton = true
        
        // Define custom action for back button.
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = newBackButton;
    }
    
    /** When clicking on back button, send the filter information to server and then go back.
    */
    func back(sender: UIBarButtonItem){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(self.filterDict, forKey: "filterDict")
        print("Sending filter dictionary.")
        sendFilter(){ (status) in
            if status == 201{
                print("Send filter: OK")
            }else{
                print("Send filter: NOT OK")
                print("Status code = \(status)")
            }
        }
        // Go back with animation.
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }

    /** Sends the filter information to the server.
    */
    func sendFilter(complete:(status:Int) -> Void){
        let defaults = NSUserDefaults.standardUserDefaults()
        let uid = defaults.integerForKey("uid")
        let authToken = defaults.stringForKey("authtoken")!
        
        var filterList = [String]()
        for (act, selected) in filterDict{
            if selected == true{
                filterList.append(act)
            }
        }
        
        // Set parameter and urlstring.
        let parameterDict:[String:NSObject] = ["UserID":uid, "uid": uid, "authtoken":authToken, "filter":filterList]
        let urlString = APIURL + "/users/setFilter"
        // Send request.
        Alamofire.request(.POST, urlString, parameters: parameterDict,
            encoding: .JSON).responseJSON { response in
                if response.response!.statusCode == 200{
                    let status = JSON(response.result.value!)["status"].intValue
                    complete(status:status)
                }
                else{
                    complete(status: response.response!.statusCode)
                }
        }
    }
    
    /*
     * Set number of sections for the tableview.
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /*
    * Set number of rows for tableview.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityTypeArr.count
    }
    
    /* Gets the contents for cells.
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let activityType = activityTypeArr[indexPath.row]
        print(activityType)
        
        // Used "dequeueReusableCellWithIdentifier" to load cell automatedly after scrolling.
        if let cell = tableView.dequeueReusableCellWithIdentifier("ActivityTypeCell", forIndexPath: indexPath) as? ActivityTypeCell {
            cell.updateCell(activityType, isSelected: filterDict[activityType]!)
            return cell
        } else {
            let cell = ActivityTypeCell()
            cell.initContent()
            cell.updateCell(activityType, isSelected: filterDict[activityType]!)
            return cell
        }
    }
    
    /* Sets the height for cells.
    */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    /** Select, or deselect an activity when clicking on it.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        // Get index of selected row.
        let index = tableView.indexPathForSelectedRow!
        
        // Set the state of select.
        let selectedCell = tableView.cellForRowAtIndexPath(index) as! ActivityTypeCell!;
        print("Selected \(selectedCell.activityTypeName.text)")
        if let prev = filterDict[selectedCell.activityTypeName.text!]{
            filterDict[selectedCell.activityTypeName.text!] = !prev
        }
        else{
            filterDict[selectedCell.activityTypeName.text!] = true
        }
        selectedCell.didSelect()
        
        // Deselect this row.
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

    }
    

}