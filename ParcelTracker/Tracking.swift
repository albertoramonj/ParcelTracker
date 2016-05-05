//
//  Tracking.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class Tracking: NSObject {
    private(set) var tCourier:String
    private(set) var tCourierLogo:String
    private(set) var tNumber:String
    private(set) var tStatus:Checkpoint
    private(set) var tHistory:[Checkpoint]
    
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
        tCourier = aDecoder.decodeObjectForKey("tCourier") as! String
        tCourierLogo = aDecoder.decodeObjectForKey("tCourierLogo") as! String
        tNumber = aDecoder.decodeObjectForKey("tNumber") as! String
        tStatus = aDecoder.decodeObjectForKey("tStatus") as! Checkpoint
        tHistory = aDecoder.decodeObjectForKey("tHistory") as! [Checkpoint]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(tCourier, forKey: "tCourier")
        aCoder.encodeObject(tCourierLogo, forKey: "tCourierLogo")
        aCoder.encodeObject(tNumber, forKey: "tNumber")
        aCoder.encodeObject(tStatus, forKey: "tStatus")
        aCoder.encodeObject(tHistory, forKey: "tHistory")
    }
}
