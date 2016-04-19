//
//  Checkpoint.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class Checkpoint: NSObject {
    private(set) var _status: String
    private(set) var _statusDetails: String
    private(set) var _statusDate: String
    private(set) var _location: String
    
    init(data: JSONDictionary) {
        if let status = data["status"] as? String {
            self._status = status
        } else {
            _status = "-"
        }
        
        if let statusDetails = data["status_details"] as? String {
            self._statusDetails = statusDetails
        } else {
            _statusDetails = "-"
        }
        
        if let statusDate = data["status_date"] as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.dateFromString(statusDate)
            if date != nil {
                dateFormatter.dateFormat = "YYYY/dd/MM hh:mm a"
                let formatedDate = dateFormatter.stringFromDate(date!)
                self._statusDate = formatedDate
            } else {
                _statusDate = "-"
            }
        } else {
            _statusDate = "-"
        }
        
        if let location = data["location"] as? JSONDictionary,
            city = location["city"] as? String {            
            self._location = city
        } else {
            _location = "-"
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        _status = aDecoder.decodeObjectForKey("status") as! String
        _statusDetails = aDecoder.decodeObjectForKey("statusDetails") as! String
        _statusDate = aDecoder.decodeObjectForKey("statusDate") as! String
        _location = aDecoder.decodeObjectForKey("location") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(_status, forKey: "status")
        aCoder.encodeObject(_statusDetails, forKey: "statusDetails")
        aCoder.encodeObject(_statusDate, forKey: "statusDate")
        aCoder.encodeObject(_location, forKey: "location")
    }
}
