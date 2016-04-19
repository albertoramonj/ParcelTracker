//
//  CheckpointTableViewCell.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 19/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class CheckpointTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusDetailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var row:Int?
    
    var checkpoint:Checkpoint? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        if row! % 2 == 0 {
            contentView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.1)
        } else {
            contentView.backgroundColor = UIColor.whiteColor()
        }
        
        let pointSize = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote).pointSize
        let customFontLight = UIFont(name: "HelveticaNeue-Light", size: pointSize)
        let customFontBold = UIFont(name: "HelveticaNeue-Bold", size: pointSize)
        dateLabel.font = customFontLight
        statusDetailLabel.font = customFontBold
        locationLabel.font = customFontBold
        
        dateLabel.text = "\(checkpoint!._statusDate)"
        statusDetailLabel.text = "\(checkpoint!._statusDetails)"
        locationLabel.text = "\(checkpoint!._location)"
    }
}
