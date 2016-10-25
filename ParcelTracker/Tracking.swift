//
//  Tracking.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class Tracking: NSObject {
    fileprivate(set) var tCourier:String
    fileprivate(set) var tCourierLogo:String
    fileprivate(set) var tNumber:String
    fileprivate(set) var tStatus:Checkpoint
    fileprivate(set) var tHistory:[Checkpoint]
    
    init(tCourier:String, tCourierLogo:String, tNumber:String, tStatus:Checkpoint,
         tHistory:[Checkpoint]) {
        
        self.tCourier = tCourier
        self.tCourierLogo = tCourierLogo
        self.tNumber = tNumber
        self.tStatus = tStatus
        self.tHistory = tHistory
    }
    
    override init() {
        self.tCourier = ""
        self.tCourierLogo = ""
        self.tNumber = ""
        self.tStatus = Checkpoint()
        self.tHistory = [Checkpoint]()
    }
    
    required init(coder aDecoder: NSCoder) {
        tCourier = aDecoder.decodeObject(forKey: "tCourier") as! String
        tCourierLogo = aDecoder.decodeObject(forKey: "tCourierLogo") as! String
        tNumber = aDecoder.decodeObject(forKey: "tNumber") as! String
        tStatus = aDecoder.decodeObject(forKey: "tStatus") as! Checkpoint
        tHistory = aDecoder.decodeObject(forKey: "tHistory") as! [Checkpoint]
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(tCourier, forKey: "tCourier")
        aCoder.encode(tCourierLogo, forKey: "tCourierLogo")
        aCoder.encode(tNumber, forKey: "tNumber")
        aCoder.encode(tStatus, forKey: "tStatus")
        aCoder.encode(tHistory, forKey: "tHistory")
    }
}
