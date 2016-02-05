//
//  File.swift
//  Let'sGo
//
//  Created by Xi Yang on 10/21/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import Foundation
import Alamofire

class ActivityList : NSObject{
    var activities: [Activity]?
    
    override init() {
        super.init()
        activities = [Activity]()
    }
    
    /** This function returns the activity at index.
     * - parameter index: (Int)
     * - return an Activity Object
    */
    func getActivityAtIndex(index : Int) -> Activity{
        return self.activities![index]
    }
    
    /** Function for fetching the activity list from the server
     *- return an ActivityList Object
    */
    func fetchList(complete:(status:Int) -> Void) {
    }

    /** This function parses JSON to activities and save them.
     *- parameter json: (JSON) string
    */
    func parseJSON(json: JSON) {
        self.activities!.removeAll()
        for result in json["acts"].arrayValue {
            let activity = Activity(result: result)
            activities!.append(activity)
        }
    }

    /** This function returns the number of activities.
     * - returns: (Int)
    */
    func activityCount() -> Int{
        if activities == nil{
            return 0
        }
        else{
            return activities!.count
        }
    }
    
}

class MyActivityList: ActivityList {
    /// This function gets the activity history from the server.
    override func fetchList(complete:(status:Int) -> Void) {

        let urlString = APIURL + "/activities/getByUserID"
        
        // Get user default value
        let defaults = NSUserDefaults.standardUserDefaults()
        let uid = defaults.integerForKey("uid")
        let authToken = defaults.stringForKey("authtoken")!
        
        let parameterDict:[String:NSObject] = ["UserID":uid, "uid": uid, "authtoken":authToken]
        
        Alamofire.request(.POST, urlString, parameters: parameterDict,
            encoding: .JSON).responseJSON { response in
                if response.response!.statusCode == 200{
                    let data = response.data
                    let json = JSON(data: data!)

                    self.parseJSON(json)
                    let status = JSON(response.result.value!)["status"].intValue
                    complete(status:status)
                }
                else{
                    complete(status: response.response!.statusCode)
                }
        }
        
    }
    
}

class NearbyActivityList: ActivityList, CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    
    /** This function fetches nearby activities from server without input location info.
        Gets the activities near the user's current location.
     */
    override func fetchList(complete:(status:Int) -> Void) {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
                
                // Wait for finding current location
                // The wait time is 6 seconds
                let startTime = NSDate()
                while locationManager.location == nil{
                    let elapsedTime = NSDate().timeIntervalSinceDate(startTime)
                    if elapsedTime > 6{
                        break
                    }
                    locationManager.requestLocation()
                }
                
                if let location = locationManager.location{
                    
                    let lat = location.coordinate.latitude
                    let lng = location.coordinate.longitude

                    // Get user default value
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let uid = defaults.integerForKey("uid")
                    let authToken = defaults.stringForKey("authtoken")!

                    let urlString = APIURL + "/activities/getByGeoInfo"
                    
                    let parameterDict:[String:NSObject] = ["Lat":lat, "Lng":lng, "UserID":uid, "uid": uid, "authtoken":authToken]
                    Alamofire.request(.POST, urlString, parameters: parameterDict,
                        encoding: .JSON).responseJSON { response in
                            if response.response!.statusCode == 200{
                                let data = response.data
                                let json = JSON(data: data!)

                                self.parseJSON(json)
                                let status = JSON(response.result.value!)["status"].intValue
                                complete(status:status)
                            }
                            else{
                                print("Fetch my activity list failed")
                                debugPrint(response)
                                complete(status: response.response!.statusCode)
                            }
                    }
                } else {
                    print("Error: Can't get current location!")
                    complete(status: -1)
                }
                
        }
    }
    
    /** This function fetches nearby activities from server with an input location info.
        Gets the activities near the input location.
    */
    func fetchList(_coord:CLLocationCoordinate2D?, complete:(status:Int) -> Void) {
                    
        if let coord = _coord{
            
            let lat = coord.latitude
            let lng = coord.longitude
            
            // Get user default value
            let defaults = NSUserDefaults.standardUserDefaults()
            let uid = defaults.integerForKey("uid")
            let authToken = defaults.stringForKey("authtoken")!
            
            let urlString = APIURL + "/activities/getByGeoInfo"
            
            let parameterDict:[String:NSObject] = ["Lat":lat, "Lng":lng, "UserID":uid, "uid": uid, "authtoken":authToken]
            //                    print(urlString)
            Alamofire.request(.POST, urlString, parameters: parameterDict,
                encoding: .JSON).responseJSON { response in
                    if response.response!.statusCode == 200{
                        let data = response.data
                        let json = JSON(data: data!)
                        
                        self.parseJSON(json)
                        let status = JSON(response.result.value!)["status"].intValue
                        complete(status:status)
                    }
                    else{
                        complete(status: response.response!.statusCode)
                    }
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    /// This function updates the current location with the approval from user.
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Ask for permit to get user location
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    /// This function stops the updating process once locations have been updated.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let _ = locations.first {
            // Update the location and stop updating to save energy
            locationManager.stopUpdatingLocation()
        }
    }
    
}