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
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationBar?.shadowImage = UIImage()
        
        title = tracking.tNumber
        
        sortedTrackingHistory = tracking.tHistory
        sortedTrackingHistory.sort {$0.cStatusDate > $1.cStatusDate}
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CheckpointHeaderViewCell
        headerCell.layoutMargins = UIEdgeInsets.zero
        headerCell.tracking = tracking
        return headerCell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTrackingHistory.count
    }

    fileprivate struct storyboard {
        static let cellReuseIdentifier = "checkpointCell"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.cellReuseIdentifier, for: indexPath) as! CheckpointTableViewCell
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.row = (indexPath as NSIndexPath).row
        cell.checkpoint = sortedTrackingHistory[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
}
