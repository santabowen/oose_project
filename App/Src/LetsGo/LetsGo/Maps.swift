//
//  Maps.swift
//  LetsGo
//
//  Created by lv huizhan on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import Foundation
import GoogleMaps

public class Maps : UIView{
    var mapsViewController : MapsViewController
    var maps : GMSMapView!
    
    public init(GMSMapView :maps) {
        mapsViewController = MapsViewController()
        super.init()
    }
}