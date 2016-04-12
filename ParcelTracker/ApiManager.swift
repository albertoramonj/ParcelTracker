//
//  ApiManager.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class APIManager {
    func getTracking (carrier: String, trackingNumber: String, completion: Tracking -> Void){
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let urlString : NSString = "\(BASEURL)\(carrier)/\(trackingNumber)"
        let url : NSURL = NSURL(string: urlString as String)!
        
        let task = session.dataTaskWithURL(url) {
            (data, response, error) -> Void in
            
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? JSONDictionary {
                        let tracking = Tracking(data: json)

                            let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                                dispatch_async(dispatch_get_main_queue()) {
                                    completion(tracking)
                                }
                        }
                        
                    }
                    
                } catch {
                    print("error in JSONSerialization")
                }
            }
        }
        task.resume()
    }

}