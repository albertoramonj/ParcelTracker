//
//  JsonDataExtractor.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 5/5/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation
class JsonDataExtractor {
    static func extractTrackingDataFromJson(_ trackingDataObject: AnyObject) -> Tracking {
    
        guard let data = trackingDataObject as? JSONDictionary else { return Tracking() }
        
        var tCourier = "", tCourierLogo = "", tNumber = "", tStatus = Checkpoint(),
        tHistory = [Checkpoint]()
        
        if let carrier = data["carrier"] as? String {
            tCourier = carrier
        }
        
        switch tCourier {
        case "ups":
            tCourierLogo = "ups_logo.png"
        case "usps":
            tCourierLogo = "usps_logo.png"
        case "fedex":
            tCourierLogo = "fedex_logo.png"
        default:
            tCourierLogo = ""
        }
        
        if let trackingNumber = data["tracking_number"] as? String {
            tNumber = trackingNumber
        }
        
        if let trackingStatus = data["tracking_status"] as? JSONDictionary {
            tStatus = self.fillCheckpointWithDict(trackingStatus as AnyObject)
        }
        
        if let trackingHistory = data["tracking_history"] as? JSonArray {
            let checkpoints = self.extractCheckpointsDataFromJson(trackingHistory as AnyObject)
            tHistory = checkpoints
        }
        
        let tracking = Tracking(tCourier: tCourier, tCourierLogo: tCourierLogo, tNumber: tNumber, tStatus: tStatus, tHistory: tHistory)
        
        return tracking
    
    }

    static func extractCheckpointsDataFromJson(_ checkpointDataObject: AnyObject) -> [Checkpoint] {
        guard let data = checkpointDataObject as? JSonArray else { return [Checkpoint]() }
        var checkpoints = [Checkpoint]()
        
        for (_, checkpoint) in data.enumerated() {
            let currentCheckpoint = self.fillCheckpointWithDict(checkpoint)
            
            checkpoints.append(currentCheckpoint)
        }
        
        return checkpoints
    }
    
    fileprivate static func fillCheckpointWithDict(_ dict: AnyObject) -> Checkpoint {
        guard let data = dict as? JSONDictionary else { return Checkpoint() }
        
        var cStatus = "", cStatusDetails = "", cStatusDate = "", cLocation = ""
        
        if let status = data["status"] as? String {
            cStatus = status
        }
        
        if let statusDetails = data["status_details"] as? String {
            cStatusDetails = statusDetails
        }
        
        if let statusDate = data["status_date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: statusDate)
            if date != nil {
                dateFormatter.dateFormat = "YYYY/dd/MM hh:mm a"
                let formatedDate = dateFormatter.string(from: date!)
                cStatusDate = formatedDate
            }
        }
        
        if let location = data["location"] as? JSONDictionary,
            let city = location["city"] as? String {
            cLocation = city
        }
        
        let currentCheckpoint = Checkpoint(cStatus: cStatus, cStatusDetails: cStatusDetails, cStatusDate: cStatusDate, cLocation: cLocation)
        
        return currentCheckpoint
    }
}

