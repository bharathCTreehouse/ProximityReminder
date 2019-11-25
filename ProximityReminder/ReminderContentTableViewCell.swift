//
//  ReminderContentTableViewCell.swift
//  ProximityReminder
//
//  Created by Bharath on 25/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class ReminderContentTableViewCell: UITableViewCell {
    
    @IBOutlet private(set) var reminderContentTextView: UITextView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func update(withContentDetail detail: (String, ReminderLabelTextAttribute)) {
        
        reminderContentTextView.font = detail.1.labelTextFont
        reminderContentTextView.textColor = detail.1.labelTextColor
        reminderContentTextView.text = detail.0
    }
    
    
    deinit {
        reminderContentTextView = nil
    }
    
}
