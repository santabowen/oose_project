//
//  S3Uploader.swift
//  LetsGo
//
//  Created by Chen Wang on 11/27/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//
//
// part of the code is from a online tutorial here, I made some modification here
// source http://sledgedev.com/aws-s3-image-upload-using-aws-sdk-for-ios-v2/
//
//

import Foundation
import Alamofire

class S3Uploader {
    
    
    var uploadRequest:AWSS3TransferManagerUploadRequest?
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var userID: String!
    var authtoken: String!
    
    
    init() {
        
//        userID = defaults.stringForKey("uid")
//        authtoken = defaults.stringForKey("authtoken")
        if defaults.stringForKey("uid") != nil {
            userID = defaults.stringForKey("uid")
        } else {
            userID = "signup"
        }
        
        if defaults.stringForKey("authtoken") != nil {
            authtoken = defaults.stringForKey("authtoken")
        } else {
            authtoken = "AUTHTOKEN"
        }
    }
    

    func uploadToS3(avatar: UIImageView, imgName: String) ->  String{
        print ("s3 \(imgName)")
        
        // get the image
        let img:UIImage = avatar.image!
        let imgURL:String = "\(ImgURLBase)\(imgName)"
        print(imgURL)
        
        // create a local image that we can use to upload to s3
        let path:NSString = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("image.png")
        let imageData:NSData = UIImagePNGRepresentation(img)!
        imageData.writeToFile(path as String, atomically: true)
        
        // once the image is saved we can use the path to create a local fileurl
        let url:NSURL = NSURL(fileURLWithPath: path as String)
        
        // next we set up the S3 upload request manager
        uploadRequest = AWSS3TransferManagerUploadRequest()
        // set the bucket
        uploadRequest?.bucket = "swift-test-letsgo"
        // I want this image to be public to anyone to view it so I'm setting it to Public Read
        uploadRequest?.ACL = AWSS3ObjectCannedACL.PublicRead
        // set the image's name that will be used on the s3 server. I am also creating a folder to place the image in
        uploadRequest?.key = "test/\(imgName)"
        // set the content type
        uploadRequest?.contentType = "image/png"
        // and finally set the body to the local file path
        uploadRequest?.body = url;
        
        // now the upload request is set up we can creat the transfermanger, the credentials are already set up in the app delegate
        let transferManager:AWSS3TransferManager = AWSS3TransferManager.defaultS3TransferManager()
        // start the upload
        transferManager.upload(uploadRequest).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock:{ [unowned self]
            task -> AnyObject in
            
            // once the uploadmanager finishes check if there were any errors
            if(task.error != nil){
                NSLog("%@", task.error);
            }else{ // if there aren't any then the image is uploaded!
                // this is the url of the image we just uploaded
                NSLog(imgURL);
            }
            
//            self.removeLoadingView()
            return "all done";
            })
    
        
        
        let  parameters = [
            "uid": userID,
            "authtoken": authtoken,
            "type": "avatar",
            "avatar": imgURL
        ]
        print("s3 avatar \(imgURL)")
    
        let urlString = APIURL + "/users/updateprofile"
        Alamofire.request(.POST, urlString, parameters: parameters)
    
        return imgURL
    }



}