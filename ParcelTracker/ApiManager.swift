//
//  ApiManager.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class APIManager {
    func getTracking (_ trackingNumber: String, completion: @escaping (Tracking) -> Void){
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        
        let courier = getCourier(trackingNumber)
        if courier == "" {
            return
        }
        let urlString : NSString = "\(BASEURL)\(courier)/\(trackingNumber)" as NSString
        let url : URL = URL(string: urlString as String)!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) -> Void in
            
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                    let tracking = self.parseJson(data)
                DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                completion(tracking)
                            }
                    }
            }
        }) 
        task.resume()
    }
    
    func parseJson(_ data: Data?) -> Tracking {
        do {
            if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject? {
                // Because this is a static func we do not have to instantiate the object
                return JsonDataExtractor.extractTrackingDataFromJson(json)
            }
        } catch {
            print("Failed to parse data: \(error)")
        }
        return Tracking()
    }
    
    func getCourier(_ trackingNumber: String) -> String {
        var courier = ""
        
        if (trackingNumber.range(of: "(1Z\\w{16})", options: .regularExpression) != nil) { courier = "ups"
        } else if (trackingNumber.range(of: "\\d{12,19}", options: .regularExpression) != nil) { courier = "fedex"
        } else if (trackingNumber.range(of: "(7\\d{19})|(\\d{1}3\\d{18})|(23\\d{18})|((EA|EC|CP|RA|LZ)\\d{9}US)|(82\\d{8})", options: .regularExpression) != nil) { courier = "usps" }
        
        return courier
    }
}
