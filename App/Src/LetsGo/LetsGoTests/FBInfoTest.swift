//
//  FBInfoTest.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 10/25/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import Foundation
import UIKit


import XCTest
@testable import LetsGo

class FBInfoTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.'
        
        // Test getting Facebook information
        let imageName = "Sign_in.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        let url = "http://graph.facebook.com/10154192072328265/picture?type=large"
        self.measureBlock {
            // Put the code you want to measure the time of here.
            loadImage(url, imageView: imageView)
        }
    }
    
}