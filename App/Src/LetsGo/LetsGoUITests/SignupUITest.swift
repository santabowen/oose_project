//
//  SignupUITest.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 11/13/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import XCTest

class SignupUITest: XCTestCase {
        
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
    
    func testSignupByEmail() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        let app = XCUIApplication()
        let createAnAccountButton = app.buttons["Create an account"]
        createAnAccountButton.tap()
        app.buttons["Have an account? Login"].tap()
        createAnAccountButton.tap()
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("jason@jhu.edu")
        
        let nickNameTextField = app.textFields["Nick name"]
        nickNameTextField.tap()
        nickNameTextField.typeText("Jason")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        
        let window = app.childrenMatchingType(.Window).elementBoundByIndex(0)
//        window.childrenMatchingType(.Other).elementBoundByIndex(2).childrenMatchingType(.Other).element.childrenMatchingType(.Button).elementBoundByIndex(1).tap()
//        app.buttons["Male"].tap()
//        passwordSecureTextField.typeText("qweasdzxc")
//        
//        let confirmPasswordSecureTextField = app.secureTextFields["Confirm password"]
//        confirmPasswordSecureTextField.tap()
//        confirmPasswordSecureTextField.typeText("qweasdzxc")
//        app.buttons["Change Photo"].tap()
//        
//        let chooseExistingPhotoButton = app.sheets.collectionViews.buttons["Choose Existing Photo"]
//        chooseExistingPhotoButton.tap()
//        app.tables.buttons["Moments"].tap()
//        app.collectionViews.cells["Photo, Landscape, August 08, 2012, 2:52 PM"].tap()
//        window.childrenMatchingType(.Other).elementBoundByIndex(3).childrenMatchingType(.Other).element.tap()
//        app.buttons["Create"].tap()
        
//        let okButton = app.alerts["Signup failed!"].collectionViews.buttons["OK"]
//        okButton.tap()
    }
}
