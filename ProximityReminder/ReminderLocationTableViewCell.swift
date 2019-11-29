//
//  ReminderLocationTableViewCell.swift
//  ProximityReminder
//
//  Created by Bharath on 26/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class ReminderLocationTableViewCell: UITableViewCell {
    
    @IBOutlet private(set) var notifierTypeLabel: UILabel!
    @IBOutlet private(set) var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func update(notifierTypeWith notifierDetail: (String, ReminderLabelTextAttribute) ) {
        
        notifierTypeLabel.font = notifierDetail.1.labelTextFont
        notifierTypeLabel.textColor = notifierDetail.1.labelTextColor
        notifierTypeLabel.text = notifierDetail.0
    }
    
    
    func update(locationWith locationDetail: (String, ReminderLabelTextAttribute) ) {
        
        locationLabel.font = locationDetail.1.labelTextFont
        locationLabel.textColor = locationDetail.1.labelTextColor
        locationLabel.text = locationDetail.0
        
    }
    
    
    func reactToActivationState(_ enabled: Bool) {
        
        if enabled == true {
            contentView.alpha = 1.0
        }
        else {
            contentView.alpha = 0.3
        }
    }
    
    
    deinit {
        notifierTypeLabel = nil
        locationLabel = nil
    }
    
}
