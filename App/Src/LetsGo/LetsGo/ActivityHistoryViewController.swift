//
//  ActivityHistoryViewController.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 11/28/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit


class ActivityHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    // TODO:
    @IBAction func screenGesture(sender: UIScreenEdgePanGestureRecognizer) {
    }
    
    @IBOutlet weak var showAllActivity: UILabel!
    @IBOutlet weak var listSwitchBtn: UISwitch!
    
    var activities = [Activity]()
    var activities_noend = [Activity]()
    var activities_all = [Activity]()
    var activityList: MyActivityList!
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().postNotificationName("disableScroll", object: nil)
        
        self.automaticallyAdjustsScrollViewInsets = false
        activityTableView.delegate = self
        activityTableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        
        self.activityList = MyActivityList()
        self.activityList.fetchList { (status) -> Void in
            if status == 201 {
                for act in self.activityList.activities! {
                    if act.isFinished == false {
                        self.activities_noend.append(act)
                    }
                    if act.memberNumber > 1 {
                        self.activities_all.append(act)
                    }
                }

                if showAllActivityHistory {
                    self.activities = self.activities_all
                } else {
                    self.activities = self.activities_noend
                }
                self.activityTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if showAllActivityHistory {
            self.listSwitchBtn.setOn(true, animated: false)
        } else {
            self.listSwitchBtn.setOn(false, animated: false)
        }
    }

    
    override func viewDidLayoutSubviews() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        self.tableView.frame = CGRect(x: 0, y: 105, width: (screenSize.width), height: (screenSize.height-155))
        
        let switchWidth = self.listSwitchBtn.frame.width
        let switchHeight = self.listSwitchBtn.frame.height
        self.listSwitchBtn.frame = CGRect(
            x: screenSize.width - switchWidth - 10,
            y: screenSize.height - switchHeight - 10,
            width: switchWidth,
            height: switchHeight)
        self.showAllActivity.frame = CGRect(
            x: self.listSwitchBtn.frame.minX - self.showAllActivity.frame.width - 10,
            y: self.listSwitchBtn.frame.midY - self.showAllActivity.frame.height/2.0,
            width: self.showAllActivity.frame.width,
            height: self.showAllActivity.frame.height)
    }
    
    // MARK: switch activity list
    
    @IBAction func switchList(sender: UISwitch) {
        if sender.on {
            self.activities = self.activities_all
            showAllActivityHistory = true
        } else {
            self.activities = self.activities_noend
            showAllActivityHistory = false
        }
        self.activityTableView.reloadData()
    }
    
    // MARK: - UITable view data source
    
    /// Return the number of section in the table.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellReuseIdentifier = "activitiesCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as! ActivityCell
        
        //Configure the cell...
        let activity = activities[indexPath.row]
        var avatarImg: UIImage?
        
        if let url = activity.avatarUrl {
            avatarImg = MainActivityViewController.avatarCache.objectForKey(url) as? UIImage
        }
        
        cell.updateCell(activity, img: avatarImg)
        return cell
    }
    
    ///This function set where to go when selecting a row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        
        let currentActCell = tableView.cellForRowAtIndexPath(indexPath) as! ActivityCell!
        if let finished = currentActCell.isFinished {
            if finished {
                if currentActCell.memberNum > 1 {
                    self.performSegueWithIdentifier("goRating", sender: currentActCell?.actId)
                } else {
                    let alertEmptyInfo = UIAlertController(
                        title: "No member to be rated!",
                        message: "You are the only member in this activity.",
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
                
            } else {
                self.performSegueWithIdentifier("goActivityDetail", sender: currentActCell?.actId)
            }
        }
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let actID = sender as! Int

        if (segue.identifier == "goRating") {
            let secondViewController = segue.destinationViewController as! RatingTableViewController
            secondViewController.act_id = actID
        }
        if segue.identifier == "goActivityDetail" {
            if let activityDetailViewController = segue.destinationViewController as? ActivityDetailViewController {
                activityDetailViewController.activityId = actID
            }
        }
    }
}
