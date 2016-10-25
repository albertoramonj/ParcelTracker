//
//  ParcelTrackerTests.swift
//  ParcelTrackerTests
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import XCTest
@testable import ParcelTracker

class ParcelTrackerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetCourier() {
        let upsTrackingNumber = "1Z58100E6897060652"
        XCTAssertEqual(APIManager().getCourier(upsTrackingNumber), "ups")
    }
    
    func testGetCourierFail() {
        let upsTrackingNumber = "1Z58100E689706065"
        XCTAssertEqual(APIManager().getCourier(upsTrackingNumber), "")
    }
    
}
