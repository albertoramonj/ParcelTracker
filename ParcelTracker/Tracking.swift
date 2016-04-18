//
//  Tracking.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class Tracking: NSObject {
    private(set) var _courier:String
    private(set) var _courierLogo:String
    private(set) var _trackingNumber:String
    private(set) var _trackingStatus:Checkpoint
    private(set) var _trackingHistory:[Checkpoint]
    
    init(data: JSONDictionary) {
        
        if let carrier = data["carrier"] as? String {
            self._courier = carrier
        } else {
            _courier = ""
        }
        
        switch _courier {
            case "ups":
                _courierLogo = "ups_logo.png"
            case "usps":
                _courierLogo = "usps_logo.png"
            case "fedex":
                _courierLogo = "fedex_logo.png"
            default:
                _courierLogo = ""
        }
        
        if let trackingNumber = data["tracking_number"] as? String {
            self._trackingNumber = trackingNumber
        } else {
            _trackingNumber = ""
        }
        
        if let checkpoint = data["tracking_status"] as? JSONDictionary {
            self._trackingStatus = Checkpoint(data: checkpoint)
            
        } else {
            self._trackingStatus = Checkpoint(data: Dictionary())
        }
        
        if let checkpoints = data["tracking_history"] as? JSonArray {
            var cp = [Checkpoint]()
            for checkpoint in checkpoints {
                let checkpoint = Checkpoint(data: checkpoint as! JSONDictionary)
                cp.append(checkpoint)
            }
            self._trackingHistory = cp
        } else {
            self._trackingHistory = Array()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        _courier = aDecoder.decodeObjectForKey("_courier") as! String
        _courierLogo = aDecoder.decodeObjectForKey("_courierLogo") as! String
        _trackingNumber = aDecoder.decodeObjectForKey("_trackingNumber") as! String
        _trackingStatus = aDecoder.decodeObjectForKey("_trackingStatus") as! Checkpoint
        _trackingHistory = aDecoder.decodeObjectForKey("_trackingHistory") as! [Checkpoint]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(_courier, forKey: "_courier")
        aCoder.encodeObject(_courierLogo, forKey: "_courierLogo")
        aCoder.encodeObject(_trackingNumber, forKey: "_trackingNumber")
        aCoder.encodeObject(_trackingStatus, forKey: "_trackingStatus")
        aCoder.encodeObject(_trackingHistory, forKey: "_trackingHistory")
    }
}
