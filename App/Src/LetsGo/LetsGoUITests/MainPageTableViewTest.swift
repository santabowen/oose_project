//
//  MainPageTableViewTest.swift
//  LetsGo
//
//  Created by Chen Wang on 10/26/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import XCTest

class MainPageTableViewTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        if #available(iOS 9.0, *) {
            XCUIApplication().launch()
        } else {
            // Fallback on earlier versions
        }

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    ///This function is for uitest. It tests whether we can view activities in main page
    @available(iOS 9.0, *)
    func testMainPageTableView() {
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0).staticTexts["Johns Hopkins University"].tap()
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(1).childrenMatchingType(.StaticText).matchingIdentifier("BADMINTON").elementBoundByIndex(0).swipeDown()
        
        
    }
    
    
    func testDetailedActivity() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0).staticTexts["Johns Hopkins University"].tap()
        app.staticTexts["Time: 10/05/2015 15:00"].tap()
        tablesQuery.staticTexts[" "].tap()
        tablesQuery.cells.childrenMatchingType(.StaticText).element.tap()
        
        let joinTable = app.tables.containingType(.Button, identifier:"Join").element
        joinTable.tap()
        joinTable.tap()
        joinTable.tap()
        app.navigationBars["LetsGo.ActivityDetailView"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        
    
    }
    
    func testJoinActivity() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(1).staticTexts["BADMINTON"].tap()
        tablesQuery.buttons["Join"].tap()
        
        let collectionViewsQuery = app.alerts["Let' Go"].collectionViews
        let okButton = collectionViewsQuery.buttons["OK"]
        okButton.tap()
        okButton.tap()
        okButton.tap()
        collectionViewsQuery.buttons["Cancel"].tap()
        okButton.tap()
        
        let enterTextSecureTextField = collectionViewsQuery.secureTextFields["Enter text:"]
        enterTextSecureTextField.tap()
        enterTextSecureTextField.tap()
        okButton.tap()
        okButton.tap()
        okButton.tap()
        
        let letGoElement = app.otherElements.containingType(.Alert, identifier:"Let' Go").element
        letGoElement.tap()
        letGoElement.tap()
        app.navigationBars["LetsGo.ActivityDetailView"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
    
    }
    
    

}
