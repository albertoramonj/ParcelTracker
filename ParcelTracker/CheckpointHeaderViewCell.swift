//
//  CheckpointHeaderView.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 19/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class CheckpointHeaderViewCell: UITableViewCell {
    @IBOutlet weak var courierImageView: UIImageView!
    @IBOutlet weak var courierLabel: UILabel!
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var statusDetailLabel: UILabel!
    
    var tracking:Tracking? {
        didSet {
            updateHeader()
        }
    }
    
    func updateHeader() {
        let checkpoint = tracking?._trackingStatus
        
        let pointSize = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).pointSize
        let customFontLight = UIFont(name: "HelveticaNeue-Light", size: pointSize)
        let customFontBold = UIFont(name: "HelveticaNeue-Bold", size: pointSize)
        statusDetailLabel.font = customFontBold
        trackingNumberLabel.font = customFontLight
        courierLabel.font = customFontLight
        
        courierImageView.image = UIImage(named: tracking!._courierLogo)
        courierLabel.text = tracking!._courier.uppercaseString
        statusDetailLabel.text = "\(checkpoint!._statusDetails)"
        trackingNumberLabel.text = "\(tracking!._trackingNumber)"
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
