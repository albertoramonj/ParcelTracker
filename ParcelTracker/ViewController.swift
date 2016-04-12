//
//  ViewController.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = APIManager()
        api.getTracking("ups", trackingNumber: "1Z12345E1512345676", completion: didGetTracking)
    }
    
    func didGetTracking(tracking: Tracking) {
        print(tracking._carrier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

