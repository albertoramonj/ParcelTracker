//
//  MainController.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class MainController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let api = APIManager()
    
    var trackings = [Tracking]()
    
    //Test tracking numbers (2x UPS, 2x USPS and 2x FedEx
    var testArray = ["1Z58100E6897060652", "1Z12345E1512345676", "EC904606166US", "LZ868113206US", "782791666790", "809188009383"]
    
    var refreshControl = UIRefreshControl()
    
    var filteredSearch = [Tracking]()
    let resultSearchController = UISearchController(searchResultsController: nil)
    
    var deleteTrackingIndexPath: NSIndexPath? = nil
    
    @IBOutlet weak var trackingNumberTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Actions
    @IBAction func addTracking(sender: AnyObject) {
        //If text is not empty and the courier is a valid one
        if trackingNumberTextField.text != "" && api.getCourier(trackingNumberTextField.text!) != "" {
            //If tracking number already exist, return
            for tracking in trackings {
                if tracking._trackingNumber.lowercaseString == trackingNumberTextField.text?.lowercaseString {
                    return
                }
            }
            
            addButton.hidden = true
            activityIndicator.startAnimating()
            api.getTracking(trackingNumberTextField.text!, completion: didGetTracking)
        }
    }
    
    // MARK: App lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if swift(>=2.2)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        #else
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        #endif
        
        //Hiding status bar 1px separator
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        navigationBar?.shadowImage = UIImage()
        
        //Removes left margin
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        //Controls text changes to change the self title
        trackingNumberTextField.addTarget(self, action: #selector(MainController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        setupRefreshControl()
        setupSearchControl()
        
        //Restore data
        let defaults = NSUserDefaults.standardUserDefaults()
        if let savedTrackings = defaults.objectForKey("trackings") as? NSData {
            trackings = NSKeyedUnarchiver.unarchiveObjectWithData(savedTrackings) as! [Tracking]
        }
        
        //For test purposes. Remove on production
        trackingNumberTextField.text = testArray[0]
        testArray.removeAtIndex(0)
        textFieldDidChange(trackingNumberTextField)
    }
    
    // MARK: - Funcs
    func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(MainController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView?.addSubview(refreshControl)
    }
    
    func setupSearchControl() {
        tableView.setContentOffset(CGPointMake(0, 44), animated: true)
        resultSearchController.searchResultsUpdater = self
        definesPresentationContext = true
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search any field"
        resultSearchController.searchBar.searchBarStyle = .Prominent
        tableView.tableHeaderView = resultSearchController.searchBar
    }
    
    func refresh(sender:AnyObject) {
        if trackings.count > 0 {
            addButton.hidden = true
            activityIndicator.startAnimating()
            let tempTrackings: [Tracking] = trackings
            trackings.removeAll()
            
            let downloadGroup: dispatch_group_t = dispatch_group_create();
            
            for tracking in tempTrackings {
                dispatch_group_enter(downloadGroup)
                api.getTracking(tracking._trackingNumber, completion: {tracking in
                        self.trackings.append(tracking)
                        dispatch_group_leave(downloadGroup);
                })
            }
            
            //non-blocking wait for all updates to finish
            dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), {
                dispatch_async(dispatch_get_main_queue(), {
                    self.shortArray()
                    self.storeData()
                    self.tableView.reloadData()
                    
                    self.activityIndicator.stopAnimating()
                    if self.refreshControl.refreshing {
                        self.refreshControl.endRefreshing()
                    }
                    self.addButton.hidden = false
                    
                })
            })
            
        } else {
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func shortArray() {
        self.trackings.sortInPlace { $0._trackingStatus._statusDate > $1._trackingStatus._statusDate }
    }
    
    func storeData() {
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(trackings)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(savedData, forKey: "trackings")
    }
    
    // MARK: - Callbacks
    func didGetTracking(tracking: Tracking) {
        print(tracking._courier)
        trackings.append(tracking)
        shortArray()
        storeData()
        tableView.reloadData()
        randomizeTrackingNumber()
        activityIndicator.stopAnimating()
        addButton.hidden = false
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
    
    //For test purposes. Remove on production
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
    
    func textFieldDidChange(textField: UITextField) {
        if textField.text?.characters.count > 0 {
            let courier = api.getCourier(textField.text!)
            if courier != "" {
                self.title = courier
                trackingNumberTextField.textColor = UIColor.blueColor()
                addButton.enabled = true
            } else {
                self.title = ""
                trackingNumberTextField.textColor = UIColor.redColor()
                addButton.enabled = false
            }
        }
    }
    
    func filterSearch(searchText: String) {
        filteredSearch = trackings.filter {$0._courier.lowercaseString.containsString(searchText) || $0._trackingNumber.lowercaseString.containsString(searchText) || $0._trackingStatus._location.lowercaseString.containsString(searchText) || $0._trackingStatus._status.lowercaseString.containsString(searchText) || $0._trackingStatus._statusDate.lowercaseString.containsString(searchText)}
        tableView.reloadData()
    }
    
    func confirmDelete(index: Int) {
        let alert = UIAlertController(title: "Delete tracking", message: "Are you sure you want to permanently delete it?", preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler:{(alert: UIAlertAction!) in
            if let indexPath = self.deleteTrackingIndexPath {
                print("Deleted")
                self.tableView.beginUpdates()
                
                self.trackings.removeAtIndex(indexPath.row)
                self.storeData()
                
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.deleteTrackingIndexPath = nil
                self.tableView.endUpdates()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(alert: UIAlertAction!) in
            print("Cancelled")
            self.deleteTrackingIndexPath = nil
        })
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.active {
            return filteredSearch.count
        }
        return trackings.count
    }
    
    private struct storyboard {
        static let cellReuseIdentifier = "trackingCell"
        static let segueToDetailIdentifier = "trackingDetail"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseIdentifier, forIndexPath: indexPath) as! TrackingTableViewCell
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        if resultSearchController.active {
            cell.tracking = filteredSearch[indexPath.row]
        } else {
            cell.tracking = trackings[indexPath.row]
        }

        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if editingStyle == .Delete {
                deleteTrackingIndexPath = indexPath
                confirmDelete(indexPath.row)
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachabilityStatusChanged", object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == storyboard.segueToDetailIdentifier {
            if let indexpath = tableView.indexPathForSelectedRow {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                let settingsTVC = segue.destinationViewController as! DetailTVC
                let tracking: Tracking = trackings[indexpath.row]
                settingsTVC.tracking = tracking
            }
        }
    }
}

