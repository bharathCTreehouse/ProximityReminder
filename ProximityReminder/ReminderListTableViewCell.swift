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
        
        reminderContentLabel.font = dataSource.content.titleTextDetail.attribute.labelTextFont
        reminderContentLabel.textColor = dataSource.content.titleTextDetail.attribute.labelTextColor
        reminderContentLabel.text = dataSource.content.titleTextDetail.text
        
        reminderLocationLabel.font = dataSource.locationDetail.titleTextDetail.attribute.labelTextFont
        reminderLocationLabel.textColor = dataSource.locationDetail.titleTextDetail.attribute.labelTextColor
        reminderLocationLabel.text = dataSource.locationDetail.titleTextDetail.text
        
        reminderLastModifiedLabel.font = dataSource.lastModifiedDetail.titleTextDetail.attribute.labelTextFont
        reminderLastModifiedLabel.textColor = dataSource.lastModifiedDetail.titleTextDetail.attribute.labelTextColor
        reminderLastModifiedLabel.text = "Last modified at \(dataSource.lastModifiedDetail.titleTextDetail.text)"
        
        
        reminderNotifierTypeLabel.font = dataSource.reminderNotifierTypeDetail.titleTextDetail.attribute.labelTextFont
        reminderNotifierTypeLabel.textColor = dataSource.reminderNotifierTypeDetail.titleTextDetail.attribute.labelTextColor
        reminderNotifierTypeLabel.text = dataSource.reminderNotifierTypeDetail.titleTextDetail.text
        
    }
    
    
    deinit {
        reminderContentLabel = nil
        reminderLocationLabel = nil
        reminderNotifierTypeLabel = nil
        reminderLastModifiedLabel = nil
    }
    
}
