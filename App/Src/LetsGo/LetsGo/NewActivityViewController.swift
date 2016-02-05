//
//  NewActivityViewController.swift
//  LetsGo
//
//  Created by lv huizhan on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftHTTP
import JSONJoy
import GoogleMaps
import Alamofire
import MapKit
import CoreLocation

/**
 The view controller for creating new activity.
 */
class NewActivityViewController: TabVCTemplate , UITextFieldDelegate,
CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var confirmLayoutCons: NSLayoutConstraint!
    // The popover scrolls for activity information.
    var popActivityPicker : PopActivityPicker?
    var popStartTimePicker : PopStartTimePicker?
    var popDurationPicker : PopDurationPicker?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Textfields for the properties of activity.
    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var groupSize: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var comments: UITextField!
    var mapView : GMSMapView!
    
    // The location manager saves location information.
    var locationManager:CLLocationManager!
    var locValue:CLLocationCoordinate2D?  // store current GPS
    // Google place picker for ios.
    var placePicker: GMSPlacePicker?
    // The list of places to plot on map.
    var placeList : [Place]?
    // Saves selected place.
    var selectedPlace : Place?
    var startTimeDate, durationDate : NSDate?
    var durationValue : [Int]?
    var response : NSHTTPURLResponse?
    
    var activeField: UITextField?
    
    var urlString:String?
    var moveHeight = CGFloat(0.0)  // for moving screen up
    var moveScreenUP = false
    let MOVE_UP_MARGIN = CGFloat(40.0)
    
    @IBOutlet weak var confirmButton: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        placeList = nil
    }
    
    /** Plot the places on the map.
    */
    func didUpdatePlaceList(){
        // Clear previous places and plot new ones
        
        // Clear all markers before
        print ("didUpdatePlaceList")
        mapView.clear()
        
        var centerLat = 0.0
        var centerLng = 0.0
        var placeNum = 0.0

        for place in placeList!{
            let marker = GMSMarker(position: place.coordinate!)
            if let selectPlace = self.selectedPlace {
                marker.title = selectPlace.name
                place.name = selectPlace.name
            } else {
                marker.title = place.name
            }
            marker.snippet = "Click to select."
            marker.userData = place
            marker.map = mapView
            placeNum += 1.0
            if let lat = place.coordinate?.latitude {
                centerLat += Double(lat)
            }
            if let lng = place.coordinate?.longitude {
                centerLng += Double(lng)
            }
        }
        if placeNum > 0.0 {
            centerLng /= placeNum
            centerLat /= placeNum
        }
        print("lat,lng = \(centerLat), \(centerLng)")
        mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2DMake(centerLat, centerLng), zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    /// This function enables user to select a place by tapping on it.
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!){
        // When tapped the window of marker to select it.
        if let selectedMarker = marker{
            selectedPlace = selectedMarker.userData as? Place
            location.text = selectedPlace!.name
            mapView.selectedMarker = nil
        }
    }
    
    // Dismiss keyboard by clicking "return" button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Dismiss keyboard by clicking the background
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    /** Decides which kind of action to do when clicking on a text field.
        For example, when clicking on activity picker, present the popover window.
    */
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Record which text field we are editing.
        activeField = textField
        
        switch textField {
        case activityTextField:
            resign()
            // Present the activity picker and get call back data.
            var initActivity : String? = activityTextField.text
            if activityTextField.text == ""{
                initActivity = "Basketball"
            }
            let dataChangedCallback : PopActivityPicker.PopActivityPickerCallback = { (newActivity : String, forTextField : UITextField) -> () in
                forTextField.text = newActivity
            }
            popActivityPicker!.pick(self, initActivity: initActivity, dataChanged: dataChangedCallback)
            return false
        case startTimeTextField:
            // Present the start time picker and get call back data.
            resign()
            var initStartTime : NSDate?
            
            let startTimeStr = startTimeTextField.text!
            
            if startTimeStr == ""{
                initStartTime = NSDate().roundToTenMinutes()
            }
            
            let dataChangedCallback : PopStartTimePicker.PopStartTimePickerCallback = { (newStartTime : NSDate, forTextField : UITextField) -> () in
                self.startTimeDate = newStartTime
                forTextField.text = (self.startTimeDate!.toDateMediumString() ?? "?") as String
            }
            popStartTimePicker!.pick(self, initStartTime: initStartTime, dataChanged: dataChangedCallback)
            return false
        case durationTextField:
            // Present the duration picker and get call back data.
            resign()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h:mm"
            var durationStr = durationTextField.text!
            var initDuration : NSDate?
            if durationStr == ""{
                durationStr = "1:30"
            }
            initDuration = dateFormatter.dateFromString(durationStr)
            let dataChangedCallback : PopDurationPicker.PopDurationPickerCallback = { (newDuration : NSDate, forTextField : UITextField) -> () in
                self.durationDate = newDuration
                forTextField.text = (self.durationDate!.toDurationMediumString() ?? "?") as String
            }
            popDurationPicker!.pick(self, initDuration: initDuration, dataChanged: dataChangedCallback)
            return false
        case groupSize, comments:
            scrollView.userInteractionEnabled = false
            contentView.userInteractionEnabled = false
            return true
        case location:
            return false
        default:
            scrollView.userInteractionEnabled = false
            contentView.userInteractionEnabled = false
            return true
        }
    }
    
    // The actions when a subview appears.
    override func viewDidLayoutSubviews() {
        //Set the contentSize for scrollView to disable horizontal scrolling
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        scrollView.frame = CGRect(x: 8, y: 0, width: (screenSize.width - 16), height: (screenSize.height))

        scrollView.contentSize = CGSizeMake(1, screenSize.height - 200)
        
    }
    
    /** Post the activity to server.
    */
    @IBAction func postNewActivity(sender: AnyObject) {
        // Check for illegal inputs.
        if let illegalFieldName = firstIllegalField(){
            let myAlert = UIAlertController(title: "Let's Go", message: illegalFieldName, preferredStyle: UIAlertControllerStyle.Alert)
            print(illegalFieldName)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ (ACTION) in
            }
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
            return
        }
        
        // Get information data from input fields.
        let startTimeValue = startTimeDate!.toDatetimeString()
        let durationValue = durationDate!.toDurationSeconds()
        
        let coordinate = selectedPlace!.coordinate!
        let lat = coordinate.latitude
        let lng = coordinate.longitude
        let groupSizeValue = ((groupSize.text! as NSString)).integerValue
        
        // Get user default value
        let defaults = NSUserDefaults.standardUserDefaults()
        let uid = defaults.integerForKey("uid")
        let authToken = defaults.stringForKey("authtoken")!
        
        let parameterDict = ["HostID": uid, "ActivityType": activityTextField.text!, "StartTime": startTimeValue!, "Duration": durationValue!, "GroupSize": groupSizeValue, "Location": location.text!, "Lat": lat, "Lng": lng, "Comments": comments.text!, "uid":uid, "authtoken":authToken]
        
        let myAlert = UIAlertController(title: "Let's Go", message: "Activity posted.", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ (ACTION) in

            // Clear input informations.
            self.activityTextField.text = ""
            self.startTimeTextField.text = ""
            self.durationTextField.text = ""
            self.groupSize.text = ""
            self.location.text = ""
            self.selectedPlace = nil

            // Go back to MainActivity.
            UIView.transitionFromView(self.view,
                toView: (self.tabBarController?.viewControllers![0].view)!,
                duration: 0.5,
                options: UIViewAnimationOptions.TransitionFlipFromRight,
                completion: {
                    finished in
                    if finished {
                        self.tabBarController?.selectedIndex = 0
                    }
            })
        }
        myAlert.addAction(okAction)
        
        print("before submit new activity")
        // Send the activity parameters and wait for response.
        Activity.sendActivity(urlString, parameterDict: parameterDict){(status) in
            if (status == 201){
                print("Send activity to server: OK.")
            }
            else{
                myAlert.message = "Failed to post activity."
                print("Send activity to server: NOT OK.")
            }
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
        
        
    }
    
    /// When finished editing location, starts a search.
    func textFieldDidEndEditing(textField: UITextField) {
        // Release the record
        print("textDidEndEditing")
        activeField = nil
        
        switch textField {
        case groupSize, comments, location:
            scrollView.userInteractionEnabled = true
            contentView.userInteractionEnabled = true
            if (textField == location){
                // update the map using location text.
                if textField.text != ""{
                    updateMapView(location.text){ (status) in
                        if (status == 200){
                            //                        print("Google API Query: OK. ")
                            self.didUpdatePlaceList()
                        }
                        else{
                            print("Google API Query: NOT OK. ")
                        }
                    }
                }
            }
        default:
            scrollView.userInteractionEnabled = true
            contentView.userInteractionEnabled = true
            return
        }
    }
    
    /// Update the map using location text.
    /// Using Google Places API Text Search Service.
    /// This function has been replaced by IOS Place API.
    func updateMapView(location : String?, complete: (status: Int) -> Void){
        print("update lcoation = \(location)")
        if let textStr = location{
            let prefix = GMS_QUERY_URL
            
            // Get separated words from the input string
            let textArr = textStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            // Assemble the words into a query string
            var query : String = ""
            for (index, text) in textArr.enumerate(){
                if text != ""{
                    //                    print(index, text)
                    if index == 0{
                        query = "query=" + text
                    }
                    else{
                        query = query + "+" + text
                    }
                }
            }
            
            // This key is server key for Google Places API
            // There's a quota on it for free queries.
            // FIXME: move this key to GlobalVar
            let radius = "radius=" + "5000"
            let key = "key=" + GMS_QUERY_KEY
            let url = prefix + "?" + query + "&" + radius + "&" + key
            
            //            let url = prefix + "?" + query + "&" + key
            
            Alamofire.request(.GET, url)
                .responseJSON { response in
                    print("query place -----------")
                    print("response:\(response.data)")
                    self.placeList = Place.parsePlaceList(JSONDecoder(response.data!))
                    print ("placeList = \(self.placeList?.count)")
                    let status = response.response!.statusCode
                    complete(status: status)
            }
        }
    }
    
    /** This function checks if the input fields are valid.
    *   return a string for error message.
    */
    func firstIllegalField() -> String?{
        if (activityTextField.text == ""){
            return "Activity type not selected."
        }
        if (startTimeTextField.text == ""){
            return "Start time is empty."
        }
        if (startTimeDate?.compare(NSDate()) == .OrderedAscending){
            return "Start time should be in the future?"
        }
        if (durationTextField.text == ""){
            return "Duration is empty."
        }
        if (groupSize.text! == ""){
            return "Group size is empty."
        }
        if let gs = Int(groupSize.text!){
            // Groupsize is less or equal to 0
            if gs <= 1 || gs > 99 {
                return "Group size should be 2 ~ 99."
            }
        }else{
            // Groupsize is not an integer
            return "Group size is not an integer."
        }
        if (selectedPlace == nil || location.text == ""){
            return "Location not selected."
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().postNotificationName("enableScroll", object: nil)
        /*tab id*/
        selectedTab = 1
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        urlString = APIURL + "/activities/post"
        
        // Initialize popover pickers(activity, starttime and duration).
        popActivityPicker = PopActivityPicker(forTextField: activityTextField)
        activityTextField.delegate = self
        popStartTimePicker = PopStartTimePicker(forTextField: startTimeTextField)
        startTimeTextField.delegate = self
        popDurationPicker = PopDurationPicker(forTextField: durationTextField)
        durationTextField.delegate = self
        groupSize.delegate = self
        location.delegate = self
        comments.delegate = self
        
        // Initialize the map.
        mapView = GMSMapView.mapWithFrame(CGRectMake(8, 220,
            self.view.bounds.size.width-48, self.view.bounds.size.height-360), camera: nil)
        mapView.myLocationEnabled = true
        mapView.delegate = self
        contentView.addSubview(mapView)
        
        // Initialize location info.
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Ask for permission to get user location
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        placeList = [Place]()
    }
    
    /** This function prevents the keyboard from covering the text fields.
    */
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /// This function will push up the view if the textfield will be covered by keyboard.
    func keyboardWillShow(sender: NSNotification) {
        if let _ = activeField{
            if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                if let activeTextField = self.activeField {
                    if self.view.frame.size.height - keyboardSize.height  < activeTextField.frame.origin.y + activeTextField.frame.height - self.moveHeight {
                        print("adjust")
                        let move = activeTextField.frame.origin.y + activeTextField.frame.height - self.moveHeight - (self.view.frame.size.height - keyboardSize.height)
                        self.view.frame.origin.y -= move
                        if !self.moveScreenUP {
                            self.view.frame.origin.y -= self.MOVE_UP_MARGIN
                            self.moveScreenUP = true
                        }
                        self.moveHeight += move
                        print(move)
                        print(self.moveHeight)
                        
                    }
                }
            }
        }
    }
    
    /// This function will pull down the view if it has been pushed up.
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += self.moveHeight
        if self.moveScreenUP {
            self.view.frame.origin.y += self.MOVE_UP_MARGIN
        }
        self.moveHeight = 0.0
        self.moveScreenUP = false
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /// Starts updating user location.
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Ask for permit to get user location
        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    /// Stops updating location after one has been found.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locValue = manager.location!.coordinate
        print("locationManager: \(locations)")
        if let location = locations.first {
            // Update the location and stop updating.
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: Google Place picker
    
    /** Starts google map location search.
    */
    @IBAction func pickPlace(sender: UIButton) {
        if self.locValue == nil {
            self.locValue = CLLocationCoordinate2DMake(39.3260467099732, -76.6210659691744)
        }
        
        let northEast = CLLocationCoordinate2DMake(self.locValue!.latitude + 0.001, self.locValue!
            .longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(self.locValue!.latitude - 0.001, self.locValue!.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            print ("place: \(place)")
            if let _place = place {
                self.selectedPlace = Place()
                self.selectedPlace!.setFromGMSPlace(_place)
                
                //determine the chosen is a customed place
                if _place.types[0] as! String == "synthetic_geocode" {
                    self.location.text = "Custom place"
                } else {
                    self.location.text = _place.name
                }

                self.placeList = [self.selectedPlace!]
                self.didUpdatePlaceList()
            }
        })
    }
    
    func resign() {
        resignFirstResponder()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
}
