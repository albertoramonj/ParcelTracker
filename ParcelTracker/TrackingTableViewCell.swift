//
//  TrackingTableViewCell.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 14/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class TrackingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courierLabel: UILabel!
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusDetailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var tracking:Tracking? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        courierLabel.text = tracking!._carrier
        trackingNumberLabel.text = tracking!._trackingNumber
        dateLabel.text = "\(tracking!._trackingStatus._statusDate)"
        statusDetailLabel.text = "\(tracking!._trackingStatus._status)"
        locationLabel.text = "\(tracking!._trackingStatus._location)"
    }
    
}
