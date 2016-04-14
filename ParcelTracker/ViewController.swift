//
//  ViewController.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    private let api = APIManager()
    
    var trackings = [Tracking]()
    
    //Test tracking numbers (2x UPS, 2x USPS and 2x FedEx
    var testArray = ["1Z12345E1512345676", "1Z58100E6897060652", "EC904606166US", "LZ868113206US", "782791666790", "809188009383"]
    
    @IBOutlet weak var trackingNumberTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Actions
    @IBAction func addTracking(sender: AnyObject) {
        //If text is not empty and the courier is a valid one
        if trackingNumberTextField.text != "" && api.getCourier(trackingNumberTextField.text!) != "" {
            addButton.hidden = true
            activityIndicator.startAnimating()
            api.getTracking(trackingNumberTextField.text!, completion: didGetTracking)
        }
    }
    
    // MARK: App lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if swift(>=2.2)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        #else
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachabilityStatusChanged", object: nil)
        #endif
        
        //Removes left margin
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        //Controls text changes to change the self title
        trackingNumberTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        //For test purposes. Remove on production
        trackingNumberTextField.text = testArray[0]
        testArray.removeAtIndex(0)
        textFieldDidChange(trackingNumberTextField)
    }
    
    // MARK: - Callbacks
    func didGetTracking(tracking: Tracking) {
        print(tracking._carrier)
        trackings.append(tracking)
        tableView.reloadData()
        randomizeTrackingNumber()
        activityIndicator.stopAnimating()
        addButton.hidden = false
    }
    
    func textFieldDidChange(textField: UITextField) {
        if textField.text?.characters.count > 0 {
            let courier = api.getCourier(textField.text!)
            if courier != "" {
                self.title = courier
            } else {
                self.title = ""
            }
        }
    }
    
    func reachabilityStatusChanged(notification: NSNotification) {
        let status = notification.userInfo!["networkStatusRawValue"] as! Int
        
        switch status {
        case NotReachable.rawValue:
            trackingNumberTextField.text = "No internet access"
            addButton.enabled = false
        default:
            trackingNumberTextField.text = ""
            addButton.enabled = true
        }
    }
    
    func randomizeTrackingNumber() {
        if testArray.count > 0 {
            let random = Int(arc4random_uniform(UInt32(testArray.count)))
            trackingNumberTextField.text = testArray[random]
            textFieldDidChange(trackingNumberTextField)
            testArray.removeAtIndex(random)
        } else {
            trackingNumberTextField.text = ""
        }
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackings.count
    }
    
    private struct storyboard {
        static let cellReuseIdentifier = "trackingCell"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseIdentifier, forIndexPath: indexPath) as! TrackingTableViewCell
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.tracking = trackings[indexPath.row]

        return cell
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachabilityStatusChanged", object: nil)
    }
}

