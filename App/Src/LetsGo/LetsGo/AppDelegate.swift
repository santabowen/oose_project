//
//  AppDelegate.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 10/24/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var tabBarController: UITabBarController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

//        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        tabBarController = self.window?.rootViewController as? UITabBarController
        
        
        //FIXME: move these keys to GlobalVar
        // Override point for customization after application launch.
        //FIXME: move keys to GlobalVar
        let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider.credentialsWithRegionType(AWSRegionType.USEast1, accountId:"045678704368", identityPoolId:"us-east-1:a9ca4574-2809-4356-8aed-52ce4a944778", unauthRoleArn:"arn:aws:iam::045678704368:role/Cognito_LetsGoTestUnauth_Role", authRoleArn:"arn:aws:iam::045678704368:role/Cognito_LetsGoTestAuth_Role")
        
        let configuration:AWSServiceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        
        //FIXME: move this key to GlobalVar
        // Provide GMS Service API key
        GMSServices.provideAPIKey("AIzaSyBuMQNgX4dlDlvCFUXJ00hshp2pVfaJyC8")        
        
        // Change for FB login
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//        return true
    }
    
    
    
    
    // added for FB login
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

