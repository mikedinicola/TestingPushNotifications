//
//  ControlCenterUITests.swift
//  TestingPushNotificationsUITests
//
//  Created by Nicolás García on 13-02-18.
//  Copyright © 2018 Nicolas Garcia. All rights reserved.
//

import XCTest

final class ControlCenterUITests: XCTestCase {
    
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testControlCenterInteractions() {
        let app = XCUIApplication()
        app.launchArguments.append("isRunningUITests")
        app.launch()
        
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        
        let dock = springboard.otherElements["Dock"]
        XCTAssert(dock.waitForExistence(timeout: 10))
        dock.swipeUp()
        
        let controlCenter = ControlCenter(springboard: springboard)
        XCTAssert(controlCenter.cellularDataButtonSwitch.waitForExistence(timeout: 10))

        controlCenter.cellularDataButtonSwitch.tap()
        controlCenter.cellularDataButtonSwitch.tap()
        
        controlCenter.wifiButton.tap()
        controlCenter.wifiButton.tap()
        
        controlCenter.bluetoothButton.tap()
        controlCenter.bluetoothButton.tap()
        
        controlCenter.airplaneModeButtonSwitch.tap()
        controlCenter.airplaneModeButtonSwitch.tap()
        
        controlCenter.flashlightButton.tap()
        controlCenter.flashlightButton.tap()
        
        controlCenter.doNotDisturbSwitch.tap()
        controlCenter.doNotDisturbSwitch.tap()
        
        controlCenter.orientationLockSwitch.tap()
        controlCenter.orientationLockSwitch.tap()
        
        controlCenter.closeButton.tap()
    }
    
}
