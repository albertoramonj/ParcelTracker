//
//  Checkpoint.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class Checkpoint {
    private(set) var _status: String
    private(set) var _statusDetails: String
    private(set) var _statusDate: NSDate
    private(set) var _location: String
    
    init(data: JSONDictionary) {
        if let status = data["status"] as? String {
            self._status = status
        } else {
            _status = ""
        }
        
        if let statusDetails = data["status_details"] as? String {
            self._statusDetails = statusDetails
        } else {
            _statusDetails = ""
        }
        
        if let statusDate = data["status_date"] as? NSDate {
            self._statusDate = statusDate
        } else {
            _statusDate = NSDate()
        }
        
        if let location = data["location"] as? JSONDictionary,
            city = location["city"] as? String {            
            self._location = city
        } else {
            _location = ""
        }
    }
}
