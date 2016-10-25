//
//  TrackingTableViewCell.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 14/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class TrackingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courierImageView: UIImageView!
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
        let pointSize = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote).pointSize
        let customFont = UIFont(name: "HelveticaNeue-Light", size: pointSize)
        trackingNumberLabel.font = customFont
        dateLabel.font = customFont
        statusDetailLabel.font = customFont
        locationLabel.font = customFont
        
        courierImageView.image = UIImage(named: tracking!.tCourierLogo)
        trackingNumberLabel.text = tracking!.tNumber
        dateLabel.text = "\(tracking!.tStatus.cStatusDate)"
        statusDetailLabel.text = "\(tracking!.tStatus.cStatus)"
        locationLabel.text = "\(tracking!.tStatus.cLocation)"
    }
    
}
