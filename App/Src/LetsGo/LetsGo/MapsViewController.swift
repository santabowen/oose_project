//
//  MapsViewController.swift
//  LetsGo
//
//  Created by lv huizhan on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import UIKit
import GoogleMaps
/**
    The view controller for pop over acitivty picker.
*/
class MapsViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(39.3289,
            longitude: -76.6203, zoom: 12)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        //        mapView.myLocationEnabled = true
        
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2DMake(39.3289, -76.6203)
        marker1.title = "Campus"
        marker1.snippet = "Johns Hopkins Univeristy"
        marker1.map = mapView
        
        //        self.view = mapView
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}