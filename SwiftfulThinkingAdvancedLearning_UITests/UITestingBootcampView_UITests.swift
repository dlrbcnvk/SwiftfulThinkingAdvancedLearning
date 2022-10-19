//
//  UITestingBootcampView_UITests.swift
//  SwiftfulThinkingAdvancedLearning_UITests
//
//  Created by 조성규 on 2022/10/18.
//

import XCTest

final class UITestingBootcampView_UITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
//        app.launchArguments = ["-UITest_startSignedIn"]
//        app.launchEnvironment = ["-UITest_startSignedIn" : "true"]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_UITestingBootcampView_signUpButton_shouldNotSignIn() {
        signUpAndSignIn(shouldTypeOnKeyboard: false)
        
        let navBar = app.navigationBars["Welcome"]
        
        XCTAssertFalse(navBar.exists)
    }
    
    func test_UITestingBootcampView_signUpButton_shouldSignIn() {
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        let navBar = app.navigationBars["Welcome"]
        
        XCTAssertTrue(navBar.exists)
    }
    
    
    
    func test_SignedInHomeView_showAlertButton_shouldDispllayAlert() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        // When
        tapAlertButton(shouldDismissAlert: false)

        // Then
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.exists)
    }
    
    func test_SignedInHomeView_showAlertButton_shouldDispllayAndDismissAlert() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        tapAlertButton(shouldDismissAlert: true)

        
        // Then
        let alertExists = app.alerts.firstMatch.waitForExistence(timeout: 3)
        XCTAssertFalse(alertExists)
    }
    
    func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestination() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        tapNavigationLink(shouldDismissDestination: false)
        
        let destinationText = app.staticTexts["Destination"]
        XCTAssertTrue(destinationText.exists)
    }
    
    
    
    func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        tapNavigationLink(shouldDismissDestination: true)

        // Then
        let navBar = app.navigationBars["Welcome"]
        XCTAssertTrue(navBar.exists)
    }
    
//    func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack2() {
//
//        // working with user starting in the signed in state
//        // app.launchArguments = ["-UITest_startSignedIn"] in setUpWithError function
//
//        tapNavigationLink(shouldDismissDestination: true)
//
//        // Then
//        let navBar = app.navigationBars["Welcome"]
//        XCTAssertTrue(navBar.exists)
//    }
}


// MARK: FUNCTIONS
extension UITestingBootcampView_UITests {
    
    func signUpAndSignIn(shouldTypeOnKeyboard: Bool) {
        let textField = app.textFields["SignUpTextField"]
        textField.tap()
        
        if shouldTypeOnKeyboard {
            let keyA = app.keys["A"]
            keyA.tap()
            let keya = app.keys["a"]
            keya.tap()
            keya.tap()
        }
        
        let returnButton = app.buttons["Return"]
        returnButton.tap()
        
        let signUpButton = app.buttons["SignUpButton"]
        signUpButton.tap()
    }
    
    func tapAlertButton(shouldDismissAlert: Bool) {
        let showAlertButton = app.buttons["ShowAlertButton"]
        showAlertButton.tap()
        
        if shouldDismissAlert {
            let alert = app.alerts.firstMatch
            let alertOKButton = alert.buttons["OK"]
            
    //        sleep(1)
            let exists = alertOKButton.waitForExistence(timeout: 3)
            XCTAssertTrue(exists)
            
            alertOKButton.tap()
        }
    }
    
    func tapNavigationLink(shouldDismissDestination: Bool) {
        let navLinkButton = app.buttons["NavigationLinkToDestination"]
        navLinkButton.tap()
        
        if shouldDismissDestination {
            let backButton = app.navigationBars.buttons["Welcome"]
            backButton.tap()
        }
    }
}
