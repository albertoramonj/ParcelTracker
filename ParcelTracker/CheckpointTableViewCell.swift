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
            contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        } else {
            contentView.backgroundColor = UIColor.white
        }
        
        let pointSize = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote).pointSize
        let customFontLight = UIFont(name: "HelveticaNeue-Light", size: pointSize)
        let customFontBold = UIFont(name: "HelveticaNeue-Bold", size: pointSize)
        dateLabel.font = customFontLight
        statusDetailLabel.font = customFontBold
        locationLabel.font = customFontBold
        
        dateLabel.text = "\(checkpoint!.cStatusDate)"
        statusDetailLabel.text = "\(checkpoint!.cStatusDetails)"
        locationLabel.text = "\(checkpoint!.cLocation)"
    }
}
