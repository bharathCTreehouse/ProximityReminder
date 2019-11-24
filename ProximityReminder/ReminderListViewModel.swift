//
//  ReminderListViewModel.swift
//  ProximityReminder
//
//  Created by Bharath on 24/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit



class ReminderListViewModel {
    
    let reminder: Reminder
    
    
    init(withReminder reminder: Reminder) {
        self.reminder = reminder
    }
}


extension ReminderListViewModel: ReminderListDisplayable {
    
    
    var photoCount: (text: String, attribute: ReminderLabelTextAttribute) {
        
        return (text: "", attribute: ReminderLabelTextAttribute(withFont: UIFont.systemFont(ofSize: 12.0), color: UIColor.lightGray))
    }
    
    var content: (text: String, attribute: ReminderLabelTextAttribute) {
        
        return (text: reminder.content, attribute: ReminderLabelTextAttribute(withFont: UIFont.italicSystemFont(ofSize: 17.0), color: UIColor.darkGray))

    }
    
    var locationDetail: (text: String, attribute: ReminderLabelTextAttribute) {
        
        return (text: reminder.locationString, attribute: ReminderLabelTextAttribute(withFont: UIFont.systemFont(ofSize: 15.0), color: UIColor.black))

    }
    
    var lastModifiedDetail: (text: String, attribute: ReminderLabelTextAttribute) {
        
        //TODO: Format the date to display only the time.
        return (text: "\(reminder.lastModifiedDate)", attribute: ReminderLabelTextAttribute(withFont: UIFont.systemFont(ofSize: 15.0), color: UIColor.black))

    }
}
