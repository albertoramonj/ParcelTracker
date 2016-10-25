//
//  Checkpoint.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class Checkpoint: NSObject {
    fileprivate(set) var cStatus: String
    fileprivate(set) var cStatusDetails: String
    fileprivate(set) var cStatusDate: String
    fileprivate(set) var cLocation: String
    
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
        cStatus = aDecoder.decodeObject(forKey: "cStatus") as! String
        cStatusDetails = aDecoder.decodeObject(forKey: "cStatusDetails") as! String
        cStatusDate = aDecoder.decodeObject(forKey: "cStatusDate") as! String
        cLocation = aDecoder.decodeObject(forKey: "cLocation") as! String
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(cStatus, forKey: "cStatus")
        aCoder.encode(cStatusDetails, forKey: "cStatusDetails")
        aCoder.encode(cStatusDate, forKey: "cStatusDate")
        aCoder.encode(cLocation, forKey: "cLocation")
    }
}
