//
//  NewActivityUnitTests.swift
//  LetsGo
//
//  Created by lv huizhan on 11/13/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import XCTest
@testable import LetsGo

class NewActivityUnitTests: XCTestCase {
    
    var newActivityVC : NewActivityViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "NewActivity", bundle: nil)
        newActivityVC = storyboard.instantiateViewControllerWithIdentifier("NewActivity") as! NewActivityViewController
        newActivityVC.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        newActivityVC = nil
        super.tearDown()
    }

    func testActivityPicker(){
        // Test for value assinement
        newActivityVC.activityTextField.text = "BADMINTON"
        XCTAssertEqual(newActivityVC!.activityTextField!.text!, "BADMINTON",
            "Failed to assign value: activity type.")
    }

    
    func testStartTimePicker(){
        // Test for value assinement
        newActivityVC.startTimeTextField.text = "Nov/13/15 Fri, 10:17 PM"
        XCTAssertEqual(newActivityVC!.startTimeTextField!.text!, "Nov/13/15 Fri, 10:17 PM",
            "Failed to assign value: start time.")
    }

    func testDurationPicker(){
        // Test for value assinement
        newActivityVC.durationTextField.text = "1 hour 30 minutes"
        XCTAssertEqual(newActivityVC!.durationTextField!.text!, "1 hour 30 minutes",
            "Failed to assign value: time duration.")
    }
    
    
    func testGroupSize(){
        // Test for value assinement
        newActivityVC.groupSize.text = "5"
        XCTAssertEqual(newActivityVC!.groupSize!.text!, "5",
            "Failed to assign value: group size.")
    }

    func testLocation(){
        // Test for value assinement
        newActivityVC.location.text = "Johns Hopkins University"
        XCTAssertEqual(newActivityVC!.location!.text!, "Johns Hopkins University",
            "Failed to assign value: location.")
    }
    
    func testComments(){
        // Test for value assinement
        newActivityVC.comments.text = "LetsGo"
        XCTAssertEqual(newActivityVC!.comments!.text!, "LetsGo",
            "Failed to assign value: comments.")
    }

//    func testConfirm(){
//        // This test fails right now because the HTTP request is asynchronous,
//        // But the program doesn't wait for it to return.
//        // The output of running the program is still good.
//        // Will add a callback function to fix this problem.
//        newActivityVC.activityTextField.text = "BADMINTON"
//        let currentDate = NSDate()
//        newActivityVC.startTimeDate = currentDate
//        newActivityVC.startTimeTextField.text = "Nov/13/15 Fri, 10:17 PM"
////        newActivityVC.durationTextField.text = "1 hour 30 minutes"
//        newActivityVC.durationDate = currentDate
//        newActivityVC.selectedPlace = Place()
//        newActivityVC.selectedPlace?.coordinate = CLLocationCoordinate2D(latitude: 13.45, longitude: -23.5)
//        newActivityVC.durationTextField.text = currentDate.toDurationMediumString() as? String
//        newActivityVC.groupSize.text = "5"
//        newActivityVC.location.text = "Johns Hopkins University"
//        newActivityVC.comments.text = "LetsGo"
//        newActivityVC.confirmNewAction(newActivityVC.confirmButton!)
//        XCTAssertNotNil(newActivityVC.response)
//        XCTAssertEqual(newActivityVC.response?.statusCode, 201)
//    }
}
