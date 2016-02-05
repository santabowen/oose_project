//
//  ProfileTableViewController.swift
//  LetsGo
//
//  Created by Chen Wang on 11/24/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit
import Alamofire


class ProfileTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    

    @IBOutlet weak var tableview: UITableView!

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var ratingView: ProfileRatingView!
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!



    private var item: Int?
    
    /// image picker to pick the image for avatar
    var imagePickerController:UIImagePickerController?
    
    var user = User()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var userID: String!
    var otherUserID: String?
    var authtoken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().postNotificationName("disableScroll", object: nil)
        
        setProfileImageShape(avatar)
    
        userID = defaults.stringForKey("uid")
        authtoken = defaults.stringForKey("authtoken")
        
//        print("user id is \(userID)")
//        print("token is \(authtoken)")
    
        
//        tableView.separatorColor = UIColor.redColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //FIXME: remove hard code
        
        if otherUserID != nil && otherUserID != userID{
            tableview.userInteractionEnabled = false
        }
        
        if otherUserID == nil {
            otherUserID = userID
        }
        
        /// after the download is finished, then call the veiw function to update the cell
        user.downloadUserInfo(userID, token: authtoken, viewUid: otherUserID!) { () -> () in
            self.updateCell()
        }
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    
    

    override func viewDidAppear(animated: Bool) {
        //FIXME: remove hard code
        if otherUserID != nil && otherUserID != userID{
            tableview.userInteractionEnabled = false
        }
        
        if otherUserID == nil {
            otherUserID = userID
        }
        
        
        user.downloadUserInfo(userID, token: authtoken, viewUid: otherUserID!) { () -> () in
                        print("avatar is \(self.user.avatar)")
            //            print("address is \(self.user.address)")
            //            print("name is \(self.user.nickName)")
            
            self.updateCell()
        }
    }

    
    /// update the cell
    func updateCell() {
        if !user.avatar!.isEmpty{
            
            print("test for image \(user.avatar!)")
            Alamofire.request(.GET, user.avatar!).validate(contentType: ["image/*"]).response(completionHandler: { (request, response, data, err) in
                if err == nil {
                    let img = UIImage(data: data!)
                    if img != nil {
                        self.avatar.image = img
                    } else {
                        self.avatar.image = UIImage(named: "default-avatar.png")
                    }
                } else {
                    self.avatar.image = UIImage(named: "default-avatar.png")
                }
            })
            
        } else {
            self.avatar.image = UIImage(named: "default-avatar.png")
        }
        
        
        
        self.nameLbl.text = self.user.nickName
        self.addressLbl.text = self.user.address
        self.ratingView.updateRating((self.user.rating?.rating)!)
        self.ratingView.show()
        self.emailLbl.text = self.user.email
        self.descriptionLbl.text = self.user.selfDescription
    }
    

    
    /// function to change the avatar image
    func changeImage() {
        
//        imagePickerController = UIImagePickerController()
//        imagePickerController?.delegate = self
//        imagePickerController?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        self.presentViewController(imagePickerController!, animated: true, completion: nil)
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "Take Photo", style: .Default, handler: { alertAction in
            // Handle Take Photo here
            // TODO: Check camera
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
    
//    func imagePickerController(picker: UIImagePickerController,
//        didFinishPickingMediaWithInfo info: [String : AnyObject]){
//            picker.dismissViewControllerAnimated(true, completion: nil)
//            avatar?.image = (info["UIImagePickerControllerOriginalImage"] as! UIImage)
//            var s3uploader = S3Uploader()
//            s3uploader.uploadToS3(avatar, imgName: "2-avatar.png")
//    }
//    
    // called when a imgae picker is clicked, s3 bucket is invoked here
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
//         avatar?.image = image
        avatar?.image = UIImage(data:image.lowestQualityJPEGNSData, scale:1.0)
        
        avatar?.image = resizeImage((avatar?.image)!, newWidth: 150)
        

        var s3uploader = S3Uploader()
        //FIXME: remove hard code
        s3uploader.uploadToS3(avatar, imgName: "\(userID)-avatar_\(randomStringWithLength(6)).png")
        

    }
    
    ///This function set where to go when selecting a row
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected row #\(indexPath.row)!")

        self.item = indexPath.row
        print(item)
        
        if indexPath.row == 0 {
            print("pressed")
            changeImage()
            
        } else if indexPath.row != 0 && indexPath.row != 3 && indexPath.row != 4{
            self.performSegueWithIdentifier("edit", sender: nil)
        }
        
    }
    
    
    /// got the the edit page, set what the user clicked and send it to the next page
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "edit" {
            if let editViewController = segue.destinationViewController as? EditViewController {
                editViewController.item = item
                editViewController.user = self.user
            }
        }
    }


}
