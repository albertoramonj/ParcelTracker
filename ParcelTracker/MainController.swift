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
    
    var deleteTrackingIndexPath: IndexPath? = nil
    
    @IBOutlet weak var trackingNumberTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Actions
    @IBAction func addTracking(_ sender: AnyObject) {
        //If text is not empty and the courier is a valid one
        if trackingNumberTextField.text != "" && api.getCourier(trackingNumberTextField.text!) != "" {
            //If tracking number already exist, return
            for tracking in trackings {
                if tracking.tNumber.lowercased() == trackingNumberTextField.text?.lowercased() {
                    return
                }
            }
            
            addButton.isHidden = true
            activityIndicator.startAnimating()
            api.getTracking(trackingNumberTextField.text!, completion: didGetTracking)
        }
    }
    
    // MARK: App lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainController.reachabilityStatusChanged), name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        
        //Hiding status bar 1px separator
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationBar?.shadowImage = UIImage()
        
        //Removes left margin
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        //Controls text changes to change the self title
        trackingNumberTextField.addTarget(self, action: #selector(MainController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        setupRefreshControl()
        setupSearchControl()
        
        //Restore data
        let defaults = UserDefaults.standard
        if let savedTrackings = defaults.object(forKey: "trackings") as? Data {
            trackings = NSKeyedUnarchiver.unarchiveObject(with: savedTrackings) as! [Tracking]
        }
        
        //For test purposes. Remove on production
        trackingNumberTextField.text = testArray[0]
        testArray.remove(at: 0)
        textFieldDidChange(trackingNumberTextField)
    }
    
    // MARK: - Funcs
    func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(MainController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl)
    }
    
    func setupSearchControl() {
        tableView.setContentOffset(CGPoint(x: 0, y: 44), animated: true)
        resultSearchController.searchResultsUpdater = self
        definesPresentationContext = true
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search any field"
        resultSearchController.searchBar.searchBarStyle = .prominent
        tableView.tableHeaderView = resultSearchController.searchBar
    }
    
    func refresh(_ sender:AnyObject) {
        if trackings.count > 0 {
            addButton.isHidden = true
            activityIndicator.startAnimating()
            let tempTrackings: [Tracking] = trackings
            trackings.removeAll()
            
            let downloadGroup: DispatchGroup = DispatchGroup();
            
            for tracking in tempTrackings {
                downloadGroup.enter()
                api.getTracking(tracking.tNumber, completion: { tracking in
                        self.trackings.append(tracking)
                        downloadGroup.leave();
                })
            }
            
            //non-blocking wait for all updates to finish
            downloadGroup.notify(queue: DispatchQueue.main, execute: {
                DispatchQueue.main.async(execute: {
                    self.shortArray()
                    self.storeData()
                    self.tableView.reloadData()
                    
                    self.activityIndicator.stopAnimating()
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                    self.addButton.isHidden = false
                    
                })
            })
            
        } else {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func shortArray() {
        self.trackings.sort { $0.tStatus.cStatusDate > $1.tStatus.cStatusDate }
    }
    
    func storeData() {
        let savedData = NSKeyedArchiver.archivedData(withRootObject: trackings)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "trackings")
    }
    
    // MARK: - Callbacks
    func didGetTracking(_ tracking: Tracking) {
        print(tracking.tCourier)
        trackings.append(tracking)
        shortArray()
        storeData()
        tableView.reloadData()
        randomizeTrackingNumber()
        activityIndicator.stopAnimating()
        addButton.isHidden = false
    }
    
    func reachabilityStatusChanged(_ notification: Notification) {
        let status = (notification as NSNotification).userInfo!["networkStatusRawValue"] as! Int
        
        switch status {
        case NotReachable.rawValue:
            trackingNumberTextField.text = "No internet access"
            addButton.isEnabled = false
        default:
            trackingNumberTextField.text = ""
            addButton.isEnabled = true
        }
    }
    
    //For test purposes. Remove on production
    func randomizeTrackingNumber() {
        if testArray.count > 0 {
            let random = Int(arc4random_uniform(UInt32(testArray.count)))
            trackingNumberTextField.text = testArray[random]
            textFieldDidChange(trackingNumberTextField)
            testArray.remove(at: random)
        } else {
            trackingNumberTextField.text = ""
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if (textField.text?.characters.count)! > 0 {
            let courier = api.getCourier(textField.text!)
            if courier != "" {
                self.title = courier
                trackingNumberTextField.textColor = UIColor.blue
                addButton.isEnabled = true
            } else {
                self.title = ""
                trackingNumberTextField.textColor = UIColor.red
                addButton.isEnabled = false
            }
        }
    }
    
    func filterSearch(_ searchText: String) {
        filteredSearch = trackings.filter {$0.tCourier.lowercased().contains(searchText) || $0.tNumber.lowercased().contains(searchText) || $0.tStatus.cLocation.lowercased().contains(searchText) || $0.tStatus.cStatus.lowercased().contains(searchText) || $0.tStatus.cStatusDate.lowercased().contains(searchText)}
        tableView.reloadData()
    }
    
    func confirmDelete(_ index: Int) {
        let alert = UIAlertController(title: "Delete tracking", message: "Are you sure you want to permanently delete it?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler:{(alert: UIAlertAction!) in
            if let indexPath = self.deleteTrackingIndexPath {
                print("Deleted")
                self.tableView.beginUpdates()
                
                self.trackings.remove(at: (indexPath as NSIndexPath).row)
                self.storeData()
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.deleteTrackingIndexPath = nil
                self.tableView.endUpdates()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
            print("Cancelled")
            self.deleteTrackingIndexPath = nil
        })
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive {
            return filteredSearch.count
        }
        return trackings.count
    }
    
    fileprivate struct storyboard {
        static let cellReuseIdentifier = "trackingCell"
        static let segueToDetailIdentifier = "trackingDetail"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.cellReuseIdentifier, for: indexPath) as! TrackingTableViewCell
        
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.tracking = resultSearchController.isActive ? filteredSearch[(indexPath as NSIndexPath).row] : trackings[(indexPath as NSIndexPath).row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if editingStyle == .delete {
                deleteTrackingIndexPath = indexPath
                confirmDelete((indexPath as NSIndexPath).row)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReachabilityStatusChanged"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == storyboard.segueToDetailIdentifier {
            if let indexpath = tableView.indexPathForSelectedRow {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                let settingsTVC = segue.destination as! DetailTVC
                let tracking: Tracking = trackings[(indexpath as NSIndexPath).row]
                settingsTVC.tracking = tracking
            }
        }
    }
}

