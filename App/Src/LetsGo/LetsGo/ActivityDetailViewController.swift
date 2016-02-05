//
//  ActivityDetailViewController.swift
//  LetsGo
//
//  Created by Xi Yang on 10/24/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy
import GoogleMaps
import Alamofire

/**
 This view is about viewing the activity detail, including type, date, time, duration, joined activity members, location text, location view, join/drop button
 */
class ActivityDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {

    /*UI controller*/
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var activityType: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var groupSizeInfo: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var joinOrDrop: UIButton!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var hostAvatarBtn: UIButton!
    
    var requestSent:Bool? //join, drop, host drop
    
    /*detail activity*/
    var activity:Activity?
    
    /*location coord*/
    let locationManager = CLLocationManager()
    var coord = CLLocationCoordinate2D()
    
    /*activity id*/
    var activityId: Int?
    /*user id when start to view other's profile*/
    var otherUserId: Int?
    /*check the activity is full*/
    var groupFull: Bool?

    /*check if the user is wether in the group*/
    var inTheActivity:Bool?
    /*check whether is the host of the activity*/
    var isTheHost: Bool?
    
//    let imageArray = 
//       [UIImage(named: "avatar1"),UIImage(named: "avatar2"),UIImage(named: "avatar3"),
//        UIImage(named: "avatar1"),UIImage(named: "avatar2"),UIImage(named: "avatar3"),
//        UIImage(named: "avatar1"),UIImage(named: "avatar2"),UIImage(named: "avatar3")]
    
    /*user's images list in group*/
    var imageArray = [UIImage]()
    /*user's id list in group*/
    var userIdArray = [Int]()
    /*check wether view user list is expanded*/
    var expanded:Bool = false
    /*check wether view group member is expanded*/
    var clickExpand:Bool = false;
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    /*user id*/
    var userID: Int?
    /*current token*/
    var authtoken: String?
    
    /**
     load view
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().postNotificationName("disableScroll", object: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.scrollEnabled = false
        locationManager.delegate = self
        joinOrDrop.layer.cornerRadius = 3

        userID = defaults.valueForKey("uid")! as? Int
        authtoken = defaults.stringForKey("authtoken")!
        
        hostAvatarBtn.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getOtherUserId:", name: "clickAvatar", object: nil)
        
        InitUI(true)
    
        self.requestSent = false
        
    }
    
    /**
     load layout view
     */
    override func viewDidLayoutSubviews() {

        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.view.frame = CGRect(x: 0, y: 7, width: (screenSize.width), height: (screenSize.height))
    }
    
    /**
    view did appear
    */
    override func viewDidAppear(animated: Bool) {
        
        for cell in tableView.visibleCells as! [AvatarCell] {
            cell.ignoreFrameChanges()
        }
    }
    /**
    deinit the view: remove all removeObserver
    */
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    getOtherUserId(): when click the subview to view the group member profile, the member id will be passed from image collectionview.
    */
    func getOtherUserId(notification: NSNotification) {
        
        if  let userId = notification.userInfo!["row"] as? NSNumber {
            self.otherUserId = userId.integerValue
            self.performSegueWithIdentifier("viewProfile", sender: nil)
        }
    }
    
    /**
     initial the number of rows in tableview
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    /**
     initial each cell in tableview
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AvatarCell
        
        cell.imageArray.removeAll()
        cell.userIdArray.removeAll()
        
        for image in self.imageArray {
            cell.imageArray.append(image)
        }
        
        for userId in self.userIdArray {
            cell.userIdArray.append(userId)
//            print("load\(userId)")
        }

        cell.initContent()
        cell.avatarCollectionView.reloadData()
        
        
//        let currentActCell = tableView.cellForRowAtIndexPath(indexPath) as! AvatarCell!;
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.4, green: 0.69, blue: 0.84, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    /**
     The listener function of clicking the cell, it will expanded or collapse the collection view based on the condition of 'clickExpand' variable
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        clickExpand = true
        
        var indexPaths : Array<NSIndexPath> = []
        indexPaths += [indexPath]
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
//        let currentActCell = tableView.cellForRowAtIndexPath(indexPath) as! AvatarCell!;
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = UIColor(red: 0.4, green: 0.69, blue: 0.84, alpha: 1.0)
//        currentActCell.selectedBackgroundView = backgroundView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        (cell as! AvatarCell).watchFrameChanges()
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//       (cell as! AvatarCell).ignoreFrameChanges()
    }
    
    /**
     initial the height of table view cell
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if clickExpand {
            expanded = !expanded
        }
        
        if expanded {
            var height:CGFloat = CGFloat(imageArray.count/8)

            if imageArray.count%8 != 0 {
                height += 1
            }
            height = height==0 ? 1:height
            return 50*height
        } else {
            return 50
        }
        
    }
    
    /**
     view will appear: hide the tab bar
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    /**
    InitUI: send the RESTful request to get the activity detail, and parse the data, load them on the view.
    */
    func InitUI(isFirst:Bool) {
        getActivity(){(status) in
            //            print("status = \(status)")
            if status == 201{
                // Check if first time initializing, if not disable join/drop for a time interval.
            }
            if !isFirst{
                self.joinOrDrop.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0);
                self.joinOrDrop.enabled = false;
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "enableJoinDrop", userInfo: nil, repeats: false)
            }
        }
    
    }

    /**
    Enable join/drop after a time interval
    */
    func enableJoinDrop() {
        if self.inTheActivity!{
            self.joinOrDrop.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0);
        }else{
            self.joinOrDrop.backgroundColor =  UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        }
        self.joinOrDrop.enabled = true
    } 

    /**
    send the RESTful request to get the activity detail, and parse the data and pass them to load view
    */
    func getActivity(complete:(status:Int) -> Void){
        let urlString = APIURL + "/activities/getsingle"
   
        Alamofire.request(.POST, urlString, parameters: ["actId":self.activityId!, "uid":self.userID!, "authtoken":self.authtoken!], encoding: .JSON).responseJSON { response in

//            print(response.result.value)
            if let json = response.result.value {
//                print("JSON: \(json)")
                
                let data = JSON(json)
                self.parseJSON(data){ (isDone) in
//                    self.showActivityGeoInfo()
                }
            }
            complete(status: (response.response?.statusCode)!)
        }
    }
    
    /**
     initial/enable the location of device
     */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
    
//            mapView.myLocationEnabled = true
//            mapView.settings.myLocationButton = true
            
        }
    }
    
    /**
     send the RESTful request to get the activity detail, and parse the data and pass them to load view
     */
    func parseJSON(json: JSON, complete:(isDone:Bool) -> Void) {
        activity = Activity(result: json["act"])
        
//        print(activity)
        
        self.inTheActivity = false
        self.isTheHost = false
        
        let actType = activity!.activityType
        let groupSize = activity!.groupSize
        let location = activity!.location
        let duration = activity!.duration
        coord.latitude = activity!.geoInfo[0]!
        coord.longitude = activity!.geoInfo[1]!
        let currentGroupSize = activity!.memberNumber
        let members = activity!.members
        let startTime = activity!.time
        
        self.showActivityGeoInfo()
        
        self.imageArray.removeAll()
        self.userIdArray.removeAll()
        for member in members! {
            let memberId = member.uid
            let avatar = member.avatar
           
            if !avatar!.isEmpty{
//                let url = NSURL(string: avatar!)
//                if let data = NSData(contentsOfURL: url!) {
//                    self.imageArray.append(UIImage(data: data)!)
//                } else {
//                    self.imageArray.append(UIImage(named: "default-avatar.png")!)
//                }
                Alamofire.request(.GET, avatar!).validate(contentType: ["image/*"]).response(completionHandler: { (request, response, data, err) in
//                    print(err)
                    if err == nil {
                        var img = UIImage(data: data!)
                        if img != nil {
//                            print("get image")
                            self.imageArray.append(maskRoundedImage(img!))
                            self.userIdArray.append(memberId)

                        } else {
//                            print("no image")
                            self.imageArray.append(maskRoundedImage(UIImage(named: "default-avatar.png")!))
                            self.userIdArray.append(memberId)
                        }
                        self.tableView.reloadData()
                    } else {
//                        print("error")
                        self.imageArray.append(maskRoundedImage(UIImage(named: "default-avatar.png")!))
                        self.userIdArray.append(memberId)
                        self.tableView.reloadData()
                    }
                })
                
            } else {
//                print("avatar empty")
                self.imageArray.append(maskRoundedImage(UIImage(named: "default-avatar.png")!))
                self.userIdArray.append(memberId)
                self.tableView.reloadData()
            }
            

//            print("load\(memberId)")
            
            if userID == memberId {
                inTheActivity = true
            }
        }
    
        if userID == activity?.hostID {
            self.isTheHost = true
            
            self.joinOrDrop.backgroundColor =  UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            if(currentGroupSize > 1) {
                self.joinOrDrop.setTitle("Drop", forState: .Normal)
            } else {
                self.joinOrDrop.setTitle("Cancel", forState: .Normal)
            }
            
        } else if self.inTheActivity! {
            self.joinOrDrop.backgroundColor =  UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            self.joinOrDrop.setTitle("Drop", forState: .Normal)

        } else {
            if groupSize > currentGroupSize {
                self.joinOrDrop.backgroundColor =  UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
                self.groupFull = false
            } else {
                self.joinOrDrop.backgroundColor =  UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
                self.groupFull = true
            }
            self.joinOrDrop.setTitle("Join", forState: .Normal)
        }
        
        self.activityType.text = "Type: "+actType
        
        self.duration.text = "Duration: " + duration!
        self.groupSizeInfo.text = String(currentGroupSize)+"/"+String(groupSize)
        self.location.text = "Location: "+location
        self.startTime.text = "Time: "+startTime
        
        let hostavatar = activity!.hostAvatar
//        if let url = NSURL(string: hostavatar!) {
//            if let data = NSData(contentsOfURL: url) {
//                self.hostAvatarBtn.setImage(UIImage(data: data), forState: .Normal)
//            }
//        }
        
        if !hostavatar!.isEmpty{
            //                let url = NSURL(string: avatar!)
            //                if let data = NSData(contentsOfURL: url!) {
            //                    self.imageArray.append(UIImage(data: data)!)
            //                } else {
            //                    self.imageArray.append(UIImage(named: "default-avatar.png")!)
            //                }
            Alamofire.request(.GET, hostavatar!).validate(contentType: ["image/*"]).response(completionHandler: { (request, response, data, err) in
                if err == nil {
                    let img = UIImage(data: data!)
                    if img != nil {
                        self.hostAvatarBtn.setImage(img!, forState: .Normal)
                    } else {
                        self.hostAvatarBtn.setImage(UIImage(named: "default-avatar.png")!, forState: .Normal)
                    }
                    setCircleButton(self.hostAvatarBtn) //FIXME
                    self.tableView.reloadData()
                } else {
                    self.hostAvatarBtn.setImage(UIImage(named: "default-avatar.png")!, forState: .Normal)
                    self.tableView.reloadData()
                }
            })
        } else {
            self.hostAvatarBtn.setImage(UIImage(named: "default-avatar.png")!, forState: .Normal)
            setCircleButton(self.hostAvatarBtn) //FIXME
        }
        setCircleButton(self.hostAvatarBtn)
        
        self.tableView.reloadData()
        complete(isDone:true)
    }
    
    /**
     showActivityGeoInfo*(): after get the activity expected happening loaction, show the geometric location on the map
    */
    func showActivityGeoInfo() {
        mapView.camera = GMSCameraPosition.cameraWithLatitude(coord.latitude, longitude: coord.longitude, zoom: 15)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(coord.latitude,coord.longitude)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
        marker.map = mapView
        
        locationManager.stopUpdatingLocation()
    }
    
    /**
     viewHostProfile(): click to view other user's profile, jump to Profile View
    */
    @IBAction func viewHostProfile(sender: AnyObject) {
        
        self.otherUserId = activity?.hostID
        self.performSegueWithIdentifier("viewProfile", sender: nil)
    }
    
    /**
     click to view other user's profile, initial the user's id and pass the data to Profile View
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewProfile" {
            if let profileViewController = segue.destinationViewController as? ProfileTableViewController {
                profileViewController.otherUserID = String(self.otherUserId!)
            }
        }
    }
    
    /**
     Button click event: join/drop Activity
     if the user was not in the acitivty, he/she could be able to join except the group was full.
     if the user was in the group, he/she could drop the activity. If he/she was the host and was the only one in the group, he/she could cancel the activity instead of drop. If there are more than one member in the group, the second member would be the host when she/he dropped the activity.
     */
    @IBAction func joinActivity(sender: UIButton) {
        
        if self.requestSent == true {
            return
        }
        
        if self.isTheHost == true {
            self.view.userInteractionEnabled = false;
            
            let urlString = APIURL + "/activities/hostdrop"
            
            Alamofire.request(.DELETE, urlString, parameters: ["ActID":self.activityId!, "UserID": self.userID!, "uid":self.userID!, "authtoken":self.authtoken!], encoding: .JSON).responseJSON { response in
                //                    debugPrint(response)
                
                if (response.result.value == nil) {
                    return
                }
                
                let result = JSON(response.result.value!)
                let status = result["status"].intValue
                if status == 201 {
                    if(self.activity!.memberNumber > 1) {
                        self.InitUI(false)
                    } else {
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                } else {
                    
                }
                self.view.userInteractionEnabled = true
                self.requestSent = false
            }
            
        } else if self.inTheActivity! {
            self.view.userInteractionEnabled = false
            let urlString = APIURL + "/activities/drop"
            print("drop")
            Alamofire.request(.DELETE, urlString, parameters: ["ActID":self.activityId!, "UserID": self.userID!, "uid":self.userID!, "authtoken":self.authtoken!], encoding: .JSON).responseJSON { response in
                //                    debugPrint(response)
                
                if (response.result.value == nil) {
                    return
                }
                
                let result = JSON(response.result.value!)
                let status = result["status"].intValue
                if status == 201 {
                    self.InitUI(false)
                } else {
                    
                }
                self.view.userInteractionEnabled = true
                self.requestSent = false
            }
        } else {

            if (self.groupFull == nil) {
                return
            }
            if (self.groupFull == true) {
                return
            }
            
            self.view.userInteractionEnabled = false
            print("join")
            let urlString = APIURL + "/activities/join"
            
            Alamofire.request(.POST, urlString, parameters: ["ActID":self.activityId!, "UserID": self.userID!, "uid":self.userID!, "authtoken":self.authtoken!], encoding: .JSON).responseJSON {response in
                
                if (response.result.value == nil) {
                    return
                }
                
                let result = JSON(response.result.value!)
                let status = result["status"].intValue
                if status == 201 {
                    self.InitUI(false)
                } else {
                    
                }
                self.view.userInteractionEnabled = true
                self.requestSent = false
            }
        }
    }

}

