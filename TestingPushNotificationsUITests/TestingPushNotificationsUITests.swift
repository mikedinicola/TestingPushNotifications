//
//  TestingPushNotificationsUITests.swift
//  TestingPushNotificationsUITests
//
//  Created by Nicolás García on 03-01-18.
//  Copyright © 2018 Nicolas Garcia. All rights reserved.
//

import XCTest
@testable import TestingPushNotifications

final class TestingPushNotificationsUITests: XCTestCase {
    
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launchArguments.append("isRunningUITests")
        app.launch()
        
        // dismiss the system dialog if it pops up
        allowPushNotificationsIfNeeded(app: app)
        
        let notificationsPermissionButton = app.buttons["notificationsButton"]
        notificationsPermissionButton.tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTapNotificationWithoutCategory() {
        
        let sendButton = app.buttons["sendWithoutCategoryButton"]
        sendButton.tap()
        
        // close app
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        
        let notification = springboard.otherElements["NotificationShortLookView"]
        XCTAssert(notification.waitForExistence(timeout: 10))

//        let notification = springboard.otherElements["TESTINGPUSHNOTIFICATIONS, now, Your bike was stolen!"]
        notification.tap()
        
        //Give time to see how the app reacts
        sleep(3)
    }
    
    func testTapNotificationActionButton() {
        
        let sendButton = app.buttons["sendButton"]
        sendButton.tap()
        
        // close app
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        
        let notification = springboard.otherElements["NotificationShortLookView"]
        XCTAssert(notification.waitForExistence(timeout: 10))
        notification.swipeDown()
        
        //Case 2a: Tap on Action Button
        let actionableNotification = SpringBoardActionableNotification(springboard: springboard)
        XCTAssert(actionableNotification.actionButton.exists)
        actionableNotification.actionButton.tap()
        
        let alert = app.alerts["Bonjour !"]
        XCTAssert(alert.waitForExistence(timeout: 10))

        //Give time to see how the app reacts
        sleep(3)
    }
    
    func testTapActionableNotification() {
        
        let sendButton = app.buttons["sendButton"]
        sendButton.tap()
        
        // close app
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        
        let notification = springboard.otherElements["NotificationShortLookView"]
        XCTAssert(notification.waitForExistence(timeout: 10))
        notification.swipeDown()
        
        //Case: Tap on notification body
        let actionableNotification = SpringBoardActionableNotification(springboard: springboard)
        XCTAssert(actionableNotification.messageButton.exists)
        actionableNotification.messageButton.tap()
        
        //Give time to see how the app reacts
        sleep(10)
    }
    
    func testCloseActionbleNotification() {
        
        let sendButton = app.buttons["sendButton"]
        sendButton.tap()
        
        // close app
        XCUIDevice.shared.press(XCUIDevice.Button.home)                
        
        let notification = springboard.otherElements["NotificationShortLookView"]
        XCTAssert(notification.waitForExistence(timeout: 10))
        notification.swipeDown()
        
        //Case: Dismiss notification
        let actionableNotification = SpringBoardActionableNotification(springboard: springboard)
        XCTAssert(actionableNotification.dismissButton.exists)
        actionableNotification.dismissButton.tap()
    }
    
    func testTextInputActionbleNotification() {
       
        let sendButton = app.buttons["sendInputButton"]
        sendButton.tap()

        // close app
        XCUIDevice.shared.press(XCUIDevice.Button.home)                
        
        //Display notification
        let notification = springboard.otherElements["NotificationShortLookView"]
        XCTAssert(notification.waitForExistence(timeout: 10))
        notification.swipeDown()
        
        //Case: Send message through notification
        let actionableNotification = SpringBoardActionableTextInputNotification(springboard: springboard)
        
        XCTAssert(actionableNotification.textField.exists)
        actionableNotification.textField.typeText("this is a test message")
        
        XCTAssert(actionableNotification.sendButton.exists)
        actionableNotification.sendButton.tap()
    }
    
}
