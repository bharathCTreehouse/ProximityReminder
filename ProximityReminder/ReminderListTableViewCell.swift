//
//  ReminderListTableViewCell.swift
//  ProximityReminder
//
//  Created by Bharath on 24/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class ReminderListTableViewCell: UITableViewCell {
    
    @IBOutlet weak private(set) var reminderContentLabel: UILabel!
    @IBOutlet weak private(set) var reminderLocationLabel: UILabel!
    @IBOutlet weak private(set) var reminderLastModifiedLabel: UILabel!
    @IBOutlet weak private(set) var reminderNotifierTypeLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func update(withReminderListDataSource dataSource: ReminderListDisplayable) {
        
        reminderContentLabel.font = dataSource.content.attribute.labelTextFont
        reminderContentLabel.textColor = dataSource.content.attribute.labelTextColor
        reminderContentLabel.text = dataSource.content.text
        
        reminderLocationLabel.font = dataSource.locationDetail.attribute.labelTextFont
        reminderLocationLabel.textColor = dataSource.locationDetail.attribute.labelTextColor
        reminderLocationLabel.text = dataSource.locationDetail.text
        
        reminderLastModifiedLabel.font = dataSource.lastModifiedDetail.attribute.labelTextFont
        reminderLastModifiedLabel.textColor = dataSource.lastModifiedDetail.attribute.labelTextColor
        reminderLastModifiedLabel.text = "Last modified at \(dataSource.lastModifiedDetail.text)"
        
        
        reminderNotifierTypeLabel.font = dataSource.reminderNotifierTypeDetail.attribute.labelTextFont
        reminderNotifierTypeLabel.textColor = dataSource.reminderNotifierTypeDetail.attribute.labelTextColor
        reminderNotifierTypeLabel.text = dataSource.reminderNotifierTypeDetail.text
        
    }
    
    
    deinit {
        reminderContentLabel = nil
        reminderLocationLabel = nil
        reminderNotifierTypeLabel = nil
        reminderLastModifiedLabel = nil
    }
    
}
