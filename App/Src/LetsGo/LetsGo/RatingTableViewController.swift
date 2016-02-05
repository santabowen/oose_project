//
//  RatingTableViewController.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 11/11/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

/**
 A class that controlls the rating table view.
 */
class RatingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var ratingTableView: UITableView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // for retriving member data from an activity
    var ratings = [Rating]()
    
    var my_uid: Int?
    var act_id: Int?
    var authtoken: String?
    
    // MARK: viewDidAppear
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
       
    }
    
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subButton.hidden = true
        
        ratingTableView.delegate = self
        ratingTableView.dataSource = self
        ratingTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.subButton.layer.cornerRadius = 2
        self.tableView.layer.cornerRadius = 5
        my_uid = defaults.valueForKey("uid") as? Int

        // get the members of a activity for rating.
        loadUsers(act_id!, uid: my_uid!, authtoken: defaults.stringForKey("authtoken")!) { (status) in
            self.ratingTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Submit rating
    
    /// Get users' name and rating and submit it to the server.
    @IBAction func submitButton(sender: UIButton) {
        let submitData = prepareSubmitData()
        
        submitRating(submitData) { (status) in
            if status == 201 {
                self.subButton.hidden = true
                for index in 0..<self.ratings.count {
                    let indexPath = NSIndexPath.init(forRow: index, inSection: self.numberOfSectionsInTableView(self.ratingTableView) - 1)
                    let cell = self.ratingTableView.cellForRowAtIndexPath(indexPath) as! RatingTableViewCell
                    
                    // Disable buttons and hide non-rated button.
                    cell.ratingControl.initRating = cell.ratingControl.rating
                    if cell.ratingControl.initRating != -1 {
                        var i = 0
                        for button in cell.ratingControl.ratingButtons {
                            if i >= Int(ceil(cell.ratingControl.initRating!)) {
                                button.alpha = 0
                            }
                            i += 1
                        }
                    }
                }
                
                // Alert message
                // Add an alter message to tell the user of this login failure
                let alert = UIAlertController(
                    title: "Rating succeed!",
                    message: "",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                // Add a "OK" button on the alter subview
                alert.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default)
                    { (action: UIAlertAction) -> Void in
                        // do nothing
                    }
                )
                // Present the alter message on the view.
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                // Alert message
                // Add an alter message to tell the user of this login failure
                let alert = UIAlertController(
                    title: "Rating Failed!",
                    message: "Please try again later.",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                // Add a "OK" button on the alter subview
                alert.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default)
                    { (action: UIAlertAction) -> Void in
                        // do nothing
                    }
                )
                // Present the alter message on the view.
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    

     /**
      Submit the rating data to the server.
     - parameter data: contains the rating for each users in an activity.
     */
    func submitRating(data: NSObject, complete: (status: Int) -> Void){
        Alamofire.request(.POST,"\(APIURL)/users/ratemember", parameters: data as? Dictionary, encoding: .JSON)
            .responseJSON { response in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    complete(status: self.parseSubmitResultJSON(JSON(response.result.value!)))
                }
        }
    }
    
    
    func parseSubmitResultJSON(json: JSON) -> Int{
        return json["status"].intValue
    }
    
    /// Get rating data (uid, rating) from each cell and prepare a dictionary that contains
    /// all the needed data for submitting to server.
    func prepareSubmitData() -> [String:NSObject]{
        var ratingData = [AnyObject]()
        
        for index in 0..<self.ratings.count {
            let indexPath = NSIndexPath.init(forRow: index, inSection: numberOfSectionsInTableView(ratingTableView) - 1)
            let cell = ratingTableView.cellForRowAtIndexPath(indexPath) as! RatingTableViewCell
            let mem = ["member_id":cell.uid!, "rating":cell.ratingControl.rating as Double]
            ratingData.append(mem)
        }
        var submitData = [String: NSObject]()
        submitData["act_id"] = act_id!
        submitData["uid"] = my_uid!
        submitData["authtoken"] = defaults.stringForKey("authtoken")!
        submitData["members"] = ratingData
        return submitData
    }
    
    // MARK: Check authentication
    
    /// Check whether the user is logged in. The user must have a authtoken and uid
    /// stored in the userdefault.
    func checkAuth(){
        if let id = defaults.valueForKey("uid") as? Int {
            self.my_uid = id
        }
        if let token = defaults.stringForKey("authtoken"){
            self.authtoken = token
        }
        
        if self.my_uid == nil || self.authtoken == nil {
            backToLogin()
        } else {
            
        }
    }
    
    /// If the user is not logged in, then go back to the login view.
    func backToLogin(){
        let mainStoryboard = UIStoryboard(name: "Login", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
        self.presentViewController(vc, animated: false, completion: nil)
    }
    
    // MARK: - UITable view data source

    /// Return the number of section in the table.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellReuseIdentifier = "ratingCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as! RatingTableViewCell

         //Configure the cell...
        let rating = ratings[indexPath.row]
        
        cell.uid = rating.uID
        cell.nameLabel.text = rating.name
        
        if let image = rating.avatar {
            cell.photoImageView.image = image
            setProfileImageShape(cell.photoImageView)
        } else {
            cell.photoImageView.image = rating.avatar
        }
      
        cell.ratingControl.rating = rating.rating!
        cell.ratingControl.initRating = rating.rating!
        if rating.rating != -1 {
            var i = 0
            for button in cell.ratingControl.ratingButtons {
                if i >= Int(ceil(rating.rating!)) {
                    button.alpha = 0
                }
                i += 1
            }
        }
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    
    // MARK: get activity members
    
    /**
    Login activity members for rating
    -parameter act_id: the id for an activity
    -parameter uid: the current user's id
    -parameter authtoken: the token for the current user given by the server
    */
    func loadUsers(act_id: Int, uid: Int, authtoken: String, complete: (status: Int) -> Void)  {
    
        Alamofire.request(.POST, "\(APIURL)/users/rating", parameters: ["act_id": act_id, "uid": uid, "authtoken": authtoken], encoding: .JSON) //FIXME: authtoken should be encrypted
            .responseJSON { response in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in

                    self.parseMemberJSON(JSON(response.result.value!)) { (status, members) in
                    
                        if status == 1 {
                            self.ratings = members
                            self.subButton.hidden = false
                        } else {
                            print(response.result.error)
                        }
                        complete(status: status)
                    }
                }
        }
    }
    
    
    /*
    Parse JSON string and return a list of Rating object containing 
    uid, name, avatar (UIIMage), and rating.
    -parameter json: the json data to be parsed
    */
    func parseMemberJSON(json: JSON, complete: (status: Int, members:[Rating]) -> Void){

        let status = json["status"].intValue
        if status != 201 {
            complete(status: status, members: [])
        }
        let membersData = json["members"].arrayValue
        
        var urls = [Int:String]()
        var members = [Rating]()
        
        // load avatar first
        for member in membersData {
            if member["member_id"].intValue != self.my_uid && member["member_avatar"].string != nil {
                urls[member["member_id"].intValue] = member["member_avatar"].string
            }
        }
        
        if urls.count == 0 {
            complete(status: 0, members: [])
            return
        }
        
        var canRate = false // determine whether there is data for rating
        getAvatar(urls) { (status, photos) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                for member in membersData {
                    if member["member_id"].intValue != self.my_uid {
                        let uid = member["member_id"].intValue
                        let name = member["member_name"].string
                        let rating = member["rating"].doubleValue
                        if rating < 0 {
                            canRate = true
                        }
                        let gender = member["member_gender"].string
                        let avatar = photos[uid]
                        members.append(Rating(uID: uid, name: name!, avatar: avatar!, gender: gender!, rating: rating))
                    }
                }

                self.subButton.enabled = canRate
                if !canRate {
                    self.subButton.alpha = 0
                }
                complete(status: status, members: members)
            }
        }
    }
    
    /**
    Download photos from Internet recursively to prevent the asynchronous HTTP beheavior that can make the download fail.
    - parameter: urls: a dictionary that contains all the uid and avatarUrl [uid: avatarUrl]
    */
    func getAvatar(urls:[Int:String], complete: (status: Int, photos:[Int:UIImage?]) -> Void){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in

            var avatars = [Int:UIImage?]()
            let firstKey = Array(urls.keys)[0]
            let url = urls[firstKey]
            var newUrls = urls
            newUrls.removeValueForKey(firstKey)
            getImageFromWeb(url!){ (status, Image) in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    avatars[firstKey] = Image
                    if newUrls.count > 0 {
                        self.getAvatar(newUrls, complete: { (status, photos) -> Void in
                            for i in photos.keys {
                                avatars[i] = photos[i]
                            }
                            complete(status: status, photos: avatars)
                        })
                    } else {
                        complete(status: status, photos: avatars)
                    }
                }
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


