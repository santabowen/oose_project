//
//  MainActivityTest.swift
//  LetsGo
//
//  Created by Chen Wang on 11/13/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import XCTest
@testable import LetsGo

class MainActivityTest: XCTestCase {
    
    var act: Activity!
    
    
    override func setUp() {
        super.setUp()
        
        let data = [ "actid": 17,
            "actType": "Baseball",
            "groupSize": 4,
            "location": "Leicester Square",
            "duration": 5400,
            "comments": "Let'sGo"
        ]
        
        
        act = Activity(result: JSON(data))
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        act = nil
        super.tearDown()
    }
    
    
    func testActivityIsInitialiced() {
        XCTAssertNotNil(act, "An act object must be returned after initialization.")
    }
    
    
    func testActivityId() {
        XCTAssertEqual(act.activityId, 17,
            "Id should be 17")
    }
    
    
    func testActivityGroupSize() {
        XCTAssertEqual(act.groupSize, 4,
            "groupsize should be 4")
    }
    
    func testActivityActType() {
        XCTAssertEqual(act.activityType, "Baseball",
            "activity type should be Baseball")
    }
    
    func testActivityLocation() {
        XCTAssertEqual(act.location, "Leicester Square",
            "location should be Leicester Square")
    }
    
    
    
    
    
    
    

    
}
