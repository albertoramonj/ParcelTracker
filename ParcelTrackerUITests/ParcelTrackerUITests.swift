//
//  ParcelTrackerUITests.swift
//  ParcelTrackerUITests
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import XCTest

class ParcelTrackerUITests: XCTestCase {
        
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
    
    func testAddTracking() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let previousCount = tablesQuery.cells.count
        
        // Pasting a new tracking number
        let trackingNumberTextField = app.textFields["TrackingNumberTextField"]
        trackingNumberTextField.tap()
        UIPasteboard.general.string = "1Z58100E6897060652"
        trackingNumberTextField.doubleTap()
        app.menuItems.element(boundBy: 2).tap()
        
        app.buttons["plus"].tap()
        sleep(3) // TODO: Testing with Stubbed Network Data
        let count = tablesQuery.cells.count
        
        XCTAssert(count == previousCount + 1)
    }
}
