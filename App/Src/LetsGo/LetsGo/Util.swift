//
//  Util.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 10/25/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import Foundation
import UIKit


/**
 Load a image from url and add it to an UIImageView.
 
 - parameter urlString: The link to a image that is going to be downloaded.
 - parameter imageView: The UIImageView for this downloaded image to display.
 */
func loadImage(urlString:String, imageView:UIImageView)
{
    let imgURL: NSURL = NSURL(string: urlString)!
    let request: NSURLRequest = NSURLRequest(URL: imgURL)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request){
        (data, response, error) -> Void in
        
        if (error == nil && data != nil)
        {
            func display_image()
            {
                imageView.image = UIImage(data: data!)
                setProfileImageShape(imageView)
            }
            dispatch_async(dispatch_get_main_queue(), display_image)
        } else {
            print(error)
        }
    }
    task.resume()
}


/**
 Make the shape of photo to circle.
 */
func setProfileImageShape(profilePhoto: UIImageView) {
    profilePhoto.contentMode = .ScaleAspectFill
    profilePhoto.layer.borderWidth = 2.0
    profilePhoto.layer.masksToBounds = false
    profilePhoto.layer.borderColor = UIColor.whiteColor().CGColor
    profilePhoto.layer.cornerRadius = profilePhoto.frame.size.height/2
    profilePhoto.clipsToBounds = true
}

/**
 Make the shape of a button with an image to circle.
 */
func setCircleButton(btn: UIButton){
    btn.layer.masksToBounds = false
    btn.layer.cornerRadius = btn.bounds.size.width / 2.0
    btn.clipsToBounds = true
}
/**
 Make a image's shape round.
 */
func maskRoundedImage(image: UIImage) -> UIImage {
    var imageView: UIImageView = UIImageView(image: image)
    var layer: CALayer = CALayer()
    layer = imageView.layer
    
    layer.masksToBounds = true
    layer.cornerRadius = imageView.bounds.size.width / 2.0
    
    UIGraphicsBeginImageContext(imageView.bounds.size)
    layer.renderInContext(UIGraphicsGetCurrentContext()!)
    var roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return roundedImage
}

/**
 Make the shape of photo to circle.
 */
func setProfileImageShapeSmall(profilePhoto: UIImageView) {
    profilePhoto.contentMode = .ScaleAspectFill
    profilePhoto.layer.cornerRadius = profilePhoto.frame.size.height/2
    profilePhoto.clipsToBounds = true
    //    profilePhoto.frame = CGRectMake(0, 0, 100, 100)
}


/**
 Download the image from web using the given url.
 -parameter url: the image link
 */
func getImageFromWeb(url: String, completion: ((status: Int, image: UIImage?) -> Void)) {
    dispatch_async(dispatch_get_main_queue()) { void in
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) {(data, response, error) in
            if error == nil && data != nil{
                completion(status: 1, image: UIImage(data: data!))
            } else {
                completion(status:0, image: nil)
            }
        }
        task.resume()
    }
}


/**
 Resize the image file before send the photo to the Amazon S3 bucket.
 */
func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
    image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}

extension UIImage {
    var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}

/**
 Return a random string.
 -parameter len: the lenth of the random string.
 */
func randomStringWithLength (len : Int) -> NSString {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    var randomString : NSMutableString = NSMutableString(capacity: len)
    
    for (var i=0; i < len; i++){
        var length = UInt32 (letters.length)
        var rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
    }
    return randomString
}
