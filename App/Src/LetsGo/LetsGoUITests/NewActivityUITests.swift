//
//  NewActivityUITests.swift
//  LetsGo
//
//  Created by lv huizhan on 10/26/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import XCTest
@testable import LetsGo

class NewActivityUITests: XCTestCase {
    
    override func setUp() {
        
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("llin34@jhu.edu")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("qweasdzxc")
        app.buttons["signin"].tap()
        app.tabBars.buttons["New"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let activityElementsQuery = scrollViewsQuery.otherElements.containingType(.StaticText, identifier:"Activity:")
        activityElementsQuery.childrenMatchingType(.TextField).elementBoundByIndex(0).tap()
        
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.staticTexts["Activity:"].tap()
        activityElementsQuery.childrenMatchingType(.TextField).elementBoundByIndex(1).tap()
        elementsQuery.staticTexts["Time:"].tap()
        activityElementsQuery.childrenMatchingType(.TextField).elementBoundByIndex(2).tap()
        elementsQuery.staticTexts["Duration:"].tap()
        activityElementsQuery.childrenMatchingType(.TextField).elementBoundByIndex(3).tap()
        elementsQuery.staticTexts["Group size:"].tap()
    }        
    
}
