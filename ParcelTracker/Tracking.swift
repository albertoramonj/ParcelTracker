//
//  Tracking.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class Tracking {
    private(set) var _carrier:String
    private(set) var _trackingNumber:String
    private(set) var _trackingStatus:Checkpoint
    private(set) var _trackingHistory:[Checkpoint]
    
    init(data: JSONDictionary) {
        
        if let carrier = data["carrier"] as? String {
            self._carrier = carrier
        } else {
            _carrier = ""
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
}
