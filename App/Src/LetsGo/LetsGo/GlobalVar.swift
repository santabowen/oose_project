//
//  GlobalVar.swift
//  Let'sGo
//
//  Created by Xi Yang on 10/15/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import Foundation
import GoogleMaps

var user: User?

var userID : Int = 1

var baseColor =  UIColor(red: 98, green: 163, blue: 197, alpha: 1)

typealias DownloadComplete = () -> ()


var devTestMode: Int = 1 //1:dev, 0:test

// Production API
let APIURL = "https://morning-brook-7884.herokuapp.com"
let GMS_QUERY_KEY = "AIzaSyCguCz0Pqeqx_ghaI6OqkUsW5xH-AzqX6g"
let GMS_QUERY_URL = "https://maps.googleapis.com/maps/api/place/textsearch/json"
let kOFFSET_FOR_KEYBOARD : CGFloat = 150
let ImgURLBase = "https://s3.amazonaws.com/swift-test-letsgo/test/"

let markerIcons = ["Basketball":GMSMarker.markerImageWithColor(UIColor.blueColor()),
    "Badminton":GMSMarker.markerImageWithColor(UIColor.greenColor()),
    "Jogging":GMSMarker.markerImageWithColor(UIColor.brownColor()),
    "Gym":GMSMarker.markerImageWithColor(UIColor.cyanColor()),
    "Tennis":GMSMarker.markerImageWithColor(UIColor.orangeColor())]

// Testing API
//let APIURL = "http://localhost:3000"

var showAllActivityHistory = true


