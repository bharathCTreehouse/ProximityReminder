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
    
    
    var reminderNotifierTypeDetail: (text: String, attribute: ReminderLabelTextAttribute) {
        
        let notifier: ReminderNotifier = ReminderNotifier(rawValue: Int(reminder.notifierType))!
        
        if notifier == .undecided {
            
            return (text: "Unspecified notifier type", attribute: ReminderLabelTextAttribute(withFont: UIFont.systemFont(ofSize: 15.0), color: UIColor.lightGray))
        }
        else {
            
            return (text: notifier.displayString, attribute: ReminderLabelTextAttribute(withFont: UIFont.systemFont(ofSize: 15.0), color: UIColor.black))
            
            //TODO: If the reminder is not activated, reduce the alpha value.
        }
    }
    
    
    var content: (text: String, attribute: ReminderLabelTextAttribute) {
        
        if reminder.content.isEmpty == true {
            
            return (text: "No reminder content", attribute: ReminderLabelTextAttribute(withFont: UIFont.systemFont(ofSize: 17.0), color: UIColor.lightGray))
        }
        else {
            return (text: reminder.content, attribute: ReminderLabelTextAttribute(withFont: UIFont.systemFont(ofSize: 17.0), color: UIColor.darkGray))
        }
    }
    
    
    var locationDetail: (text: String, attribute: ReminderLabelTextAttribute) {
        
        if reminder.locationString.isEmpty == true {
            return (text: "No reminder location", attribute: ReminderLabelTextAttribute(withFont: UIFont.systemFont(ofSize: 15.0), color: UIColor.lightGray))
        }
        else {
            return (text: reminder.locationString, attribute: ReminderLabelTextAttribute(withFont: UIFont.systemFont(ofSize: 15.0), color: UIColor.black))
            
            //TODO: If the reminder is not activated, reduce the alpha value.
        }
    }
    
    var lastModifiedDetail: (text: String, attribute: ReminderLabelTextAttribute) {
        
        //TODO: Format the date to display only the time.
        return (text: "\(reminder.lastModifiedDate)", attribute: ReminderLabelTextAttribute(withFont: UIFont.systemFont(ofSize: 15.0), color: UIColor.black))

    }
}
