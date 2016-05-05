//
//  DetailTVC.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 19/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class DetailTVC: UITableViewController {

    var tracking: Tracking!
    var sortedTrackingHistory = [Checkpoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hiding status bar 1px separator
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        navigationBar?.shadowImage = UIImage()
        
        title = tracking.tNumber
        
        sortedTrackingHistory = tracking.tHistory
        sortedTrackingHistory.sortInPlace {$0.cStatusDate > $1.cStatusDate}
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! CheckpointHeaderViewCell
        headerCell.layoutMargins = UIEdgeInsetsZero
        headerCell.tracking = tracking
        return headerCell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTrackingHistory.count
    }

    private struct storyboard {
        static let cellReuseIdentifier = "checkpointCell"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseIdentifier, forIndexPath: indexPath) as! CheckpointTableViewCell
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.row = indexPath.row
        cell.checkpoint = sortedTrackingHistory[indexPath.row]
        
        return cell
    }
    
}