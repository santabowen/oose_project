//
//  MapViewViewController.swift
//  LetsGo
//
//  Created by lv huizhan on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
/**
    The view controller for viewing activities in the map.
*/
class MapViewViewController: TabVCTemplate, CLLocationManagerDelegate
                , GMSMapViewDelegate{
    /// Go to filter
    @IBAction func toFilterBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("toFilter", sender: nil)
    }
    
    var locationManager:CLLocationManager!
    var mapView : GMSMapView!
    var nearbyActivityList : NearbyActivityList!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().postNotificationName("enableScroll", object: nil)
        
        selectedTab = 2
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Initialize GMS map view.
        let camera = GMSCameraPosition.cameraWithLatitude(39.3289,
            longitude: -76.6203, zoom: 15)
        mapView = GMSMapView.mapWithFrame(CGRectMake(0, 0,
            self.view.bounds.size.width, self.view.bounds.size.height-50), camera: camera)
        mapView.delegate = self
        self.view.addSubview(self.mapView)
        
        // Initialize location manage.
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Ask for permission to get user location
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        print("Getting nearby activitylist.")
        
        // Initiate activity list and plot on the map.
        nearbyActivityList = NearbyActivityList()
        nearbyActivityList.fetchList(){ (status) in
            if status == 201{
                self.plotMarkers(self.nearbyActivityList)
            }
            else{
                print("Cannot get activity info.")
            }
        }
        
        // Plot activity list onto the map.
        plotMarkers(nearbyActivityList)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    /** This function plots the activity list on the map
     *  - parameter activityList: (ActivityList) Object
    */
    func plotMarkers(activityList: ActivityList?){
        // Clear old markers.
        mapView.clear()
        
        // Plot the markers.
        if activityList != nil{
            for activity in (activityList!.activities)!{
                let position = CLLocationCoordinate2DMake(activity.geoInfo[0]!, activity.geoInfo[1]!)
                
                let marker = GMSMarker(position: position)
                marker.title = activity.activityType
                marker.icon = markerIcons[activity.activityType]!
                marker.snippet = activity.time + "\n" + activity.location
                marker.userData = activity
                marker.map = mapView
            }
        }
    }
    
    /** This function changes the authorization status
    */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Ask for permit to get user location
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    /** This function updates current location.
    */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Update the location and stop calling update function
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }

    /** This function updates the positions of markers after the camera moves.
    */
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
        if mapView.selectedMarker == nil{
            //call refresh
            nearbyActivityList.fetchList(position.target){(status) in
                if status == 201{
                    self.plotMarkers(self.nearbyActivityList)
                }
                else{
                    print("Cannot get activity info.")
                }
            }
        }
    }
    
    /** Prepare the values for the variables in the next viewcontroller of segue.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapToDetail" {
            if let activityDetailViewController = segue.destinationViewController as? ActivityDetailViewController {
                if let selectedActivity = mapView.selectedMarker.userData as? Activity{
                    activityDetailViewController.activityId = selectedActivity.activityId
                }
            }
        }
    }
    
    /** Perform segue to ActivityDetailViewController
    */
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        // When tapped the window of marker
        self.performSegueWithIdentifier("mapToDetail", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
         NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
}
