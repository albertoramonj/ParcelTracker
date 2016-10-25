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
        let checkpoint = tracking?.tStatus
        
        let pointSize = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).pointSize
        let customFontLight = UIFont(name: "HelveticaNeue-Light", size: pointSize)
        let customFontBold = UIFont(name: "HelveticaNeue-Bold", size: pointSize)
        statusDetailLabel.font = customFontBold
        trackingNumberLabel.font = customFontLight
        courierLabel.font = customFontLight
        
        courierImageView.image = UIImage(named: tracking!.tCourierLogo)
        courierLabel.text = tracking!.tCourier.uppercased()
        statusDetailLabel.text = "\(checkpoint!.cStatusDetails)"
        trackingNumberLabel.text = "\(tracking!.tNumber)"
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
