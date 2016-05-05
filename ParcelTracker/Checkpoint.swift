//
//  Checkpoint.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class Checkpoint: NSObject {
    private(set) var cStatus: String
    private(set) var cStatusDetails: String
    private(set) var cStatusDate: String
    private(set) var cLocation: String
    
    init(cStatus:String, cStatusDetails:String, cStatusDate:String, cLocation:String) {
        self.cStatus = cStatus
        self.cStatusDetails = cStatusDetails
        self.cStatusDate = cStatusDate
        self.cLocation = cLocation
    }
    
    override init() {
        self.cStatus = ""
        self.cStatusDetails = ""
        self.cStatusDate = ""
        self.cLocation = ""
    }
    
    required init(coder aDecoder: NSCoder) {
        cStatus = aDecoder.decodeObjectForKey("cStatus") as! String
        cStatusDetails = aDecoder.decodeObjectForKey("cStatusDetails") as! String
        cStatusDate = aDecoder.decodeObjectForKey("cStatusDate") as! String
        cLocation = aDecoder.decodeObjectForKey("cLocation") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(cStatus, forKey: "cStatus")
        aCoder.encodeObject(cStatusDetails, forKey: "cStatusDetails")
        aCoder.encodeObject(cStatusDate, forKey: "cStatusDate")
        aCoder.encodeObject(cLocation, forKey: "cLocation")
    }
}
