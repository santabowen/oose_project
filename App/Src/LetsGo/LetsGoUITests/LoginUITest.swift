//
//  LoginUITest.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 10/26/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import XCTest

class LoginUITest: XCTestCase {
    
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

    
    ///Login UI testing
    func testEmailLogin() {
        // Test Facebook login will not be performed uning automatic testing.
        // Facebook login is hard to test since the UI test will not record
        // the action when the view is directed to the Facebook login page on Safari.
        
        
        // Test enter email and password
        
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("llin34@jhu.edu")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("qwe")
        
        let signinButton = app.buttons["signin"]
        signinButton.tap()
        app.alerts["Login Failed!"].collectionViews.buttons["OK"].tap()
        passwordSecureTextField.typeText("qweasdzxc")
        signinButton.tap()
        
    }
}
