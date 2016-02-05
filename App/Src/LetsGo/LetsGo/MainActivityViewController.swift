//
//  MainActivityViewController.swift
//  Let'sGo
//
//  Created by Chen Wang on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.

import UIKit
import Alamofire

class MainActivityViewController: TabVCTemplate, UITableViewDelegate, UITableViewDataSource  {
    
    ///table view for the main activity page
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet var superView: UIView!
    
    @IBAction func toFilterBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("toFilter", sender: nil)
    }

    ///use an array to store all activities
    var nearbyActivityList = NearbyActivityList()
    
    ///selected activity ID
    var actId: Int?
    var currentActivity : Activity?
    
    static var avatarCache = NSCache()
    
    
    override func viewDidLayoutSubviews() {
//        NSLayoutConstraint(item: tableView, attribute: .Leading, relatedBy: .Equal, toItem: superView, attribute: .LeadingMargin, multiplier: 1.0, constant: 10.0).active = true
//        NSLayoutConstraint(item: tableView, attribute: .Trailing, relatedBy: .Equal, toItem: superView, attribute: .TrailingMargin, multiplier: 1.0, constant: 10.0).active = true
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        tableView.frame = CGRect(x: 8, y: 70, width: (screenSize.width - 16), height: (screenSize.height - 120))
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedTab = 0
        
        UITabBar.appearance().tintColor =  UIColor.redColor()
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        //custom tab bar
//        tabBarController?.tabBar.barTintColor = UIColor(red: 86.0/255.0, green: 159.0/255.0, blue: 204.0/255.0, alpha: 1)
        tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        
        for item in (tabBarController?.tabBar.items)! as [UITabBarItem]
        {
            item.image = item.selectedImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//            item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:UIControlState.Normal)
//            item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:UIControlState.Disabled)
//            item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:UIControlState.Selected)
        }


        tableView.delegate = self
        tableView.dataSource = self
  
        let refreshControl = UIRefreshControl()
        self.tableView.reloadData()
        self.refresh(refreshControl)
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        firstLoad(){(isDone) in
            // Wait for response.
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tabBarController?.tabBar.hidden = false
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("enableScroll", object: nil)
        
        
        MainActivityViewController.avatarCache.removeAllObjects()
        nearbyActivityList.fetchList(){(status) in
            if status == 201{
                self.tableView.reloadData()
            }
            else{
//                print("refresh: NOT OK")
            }
        }
    }
    
    
    ///When the nearby activities were first time loaded, call this func. We have a completation closure here
    func firstLoad(complete:(isDone:Bool) -> Void){
        nearbyActivityList.fetchList(){(status) in
//            print("status=\(status)")
            if status == 201{
//                print("refresh: OK")
                self.tableView.reloadData()
            }
            else{
//                print("refresh: NOT OK")
            }
            complete(isDone: true)
        }
    }
    
    /// refresh star control when you pull down the table
    func refresh(refreshControl: UIRefreshControl) {
        MainActivityViewController.avatarCache.removeAllObjects()
        nearbyActivityList.fetchList(){(status) in
            if status == 201{
//                print("refresh: OK")
                self.tableView.reloadData()
            }
            else{
//                print("refresh: NOT OK")
            }
            refreshControl.endRefreshing()
        }
    }


    ///give the information that the next segue need
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailActivity" {
            if let activityDetailViewController = segue.destinationViewController as? ActivityDetailViewController {
                activityDetailViewController.activityId = actId
//                activityDetailViewController.currentActivity =
            }
        }
    }
    
    
    //MARK: - table view delegation method
    
    /// This function returns how many logic sections you want to seperate the data in the tableview
    /// - parameter tableView: (UITableView) the table view in the main page
    /// - returns: Int type of number
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// This function returns how many rows in total in the tableview
    /// - parameter tableView: the tableview in the main page
    /// - returns: Int
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyActivityList.activityCount()
    }
    
    /// This function sets what data you want to show in a specific new cell
    /// - parameter tableView: (UITableView)
    /// - parameter indexPath: (NSIndexPath)
    /// - returns: UITableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let activity = nearbyActivityList.getActivityAtIndex(indexPath.row)
//        print("count is \(nearbyActivityList.activityCount())")
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as? ActivityCell {
            cell.request?.cancel() 
            var avatarImg: UIImage?
            
            print("url is \(activity.avatarUrl)  and id is \(activity.activityId ) and location is \(activity.location)")
            if let url = activity.avatarUrl {
                avatarImg = MainActivityViewController.avatarCache.objectForKey(url) as? UIImage
            }
            
            
            cell.updateCell(activity, img: avatarImg)
            return cell
        } else {
            let cell = ActivityCell()
//            cell.updateCell(activity)

            return cell
        }
//        return tableView.dequeueReusableCellWithIdentifier("ActivityCell") as! ActivityCell
    }
    

    /// This function returns he height of each cell for the table view
    /// - parameter tableView: the table view in the main page
    /// - parameter indexPath: (NSIndexPath)
    /// - returns: CGFloat
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
//    
    ///This function set where to go when selecting a row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("You selected cell #\(indexPath.row)!")
        let indexPath = tableView.indexPathForSelectedRow!
        
        let currentActCell = tableView.cellForRowAtIndexPath(indexPath) as! ActivityCell!;
        
        self.actId = currentActCell?.actId
        
//        print("id is \(currentActCell?.actId)")
        
        self.performSegueWithIdentifier("detailActivity", sender: nil)
    }

    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         Get the new view controller using segue.destinationViewController.
         Pass the selected object to the new view controller.
    }
    */

}
