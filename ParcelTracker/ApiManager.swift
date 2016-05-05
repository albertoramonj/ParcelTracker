//
//  ApiManager.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class APIManager {
    func getTracking (trackingNumber: String, completion: Tracking -> Void){
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let courier = getCourier(trackingNumber)
        if courier == "" {
            return
        }
        let urlString : NSString = "\(BASEURL)\(courier)/\(trackingNumber)"
        let url : NSURL = NSURL(string: urlString as String)!
        
        let task = session.dataTaskWithURL(url) {
            (data, response, error) -> Void in
            
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                    let tracking = self.parseJson(data)

                        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                completion(tracking)
                            }
                    }
            }
        }
        task.resume()
    }
    
    func parseJson(data: NSData?) -> Tracking {
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as AnyObject? {
                // Because this is a static func we do not have to instantiate the object
                return JsonDataExtractor.extractTrackingDataFromJson(json)
            }
        } catch {
            print("Failed to parse data: \(error)")
        }
        return Tracking()
    }
    
    func getCourier(trackingNumber: String) -> String {
        var courier = ""
        
        if (trackingNumber.rangeOfString("(1Z\\w{16})", options: .RegularExpressionSearch) != nil) { courier = "ups"
        } else if (trackingNumber.rangeOfString("\\d{12,19}", options: .RegularExpressionSearch) != nil) { courier = "fedex"
        } else if (trackingNumber.rangeOfString("(7\\d{19})|(\\d{1}3\\d{18})|(23\\d{18})|((EA|EC|CP|RA|LZ)\\d{9}US)|(82\\d{8})", options: .RegularExpressionSearch) != nil) { courier = "usps" }
        
        return courier
    }
}