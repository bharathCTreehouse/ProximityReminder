//
//  ReminderDetailViewModel.swift
//  ProximityReminder
//
//  Created by Bharath on 26/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderDetailViewModel {
    
    let reminder: Reminder
    
    init(withReminder reminder: Reminder) {
        self.reminder = reminder
    }
}


extension ReminderDetailViewModel: ReminderDetailDisplayable {
    
    
    var notifierTypeDetail: (text: String, attr: ReminderLabelTextAttribute) {
        
        let reminderNotifier: ReminderNotifier = ReminderNotifier(rawValue: Int(reminder.notifierType))!
        
        if reminderNotifier == .undecided {
            
            return (text: "", attr: ReminderLabelTextAttribute.init(withFont: UIFont.systemFont(ofSize: 17.0), color: UIColor.lightGray))
        }
        else {
            return (text: reminderNotifier.displayString, attr: ReminderLabelTextAttribute.init(withFont: UIFont.boldSystemFont(ofSize: 17.0), color: UIColor.black))
        }
    }
    
    var notifierActivationStatus: ReminderDualModeDisplayable {
        
        //TODO: Change the harcoded value
        let vm = ReminderDetailNotificationActivationViewModel(withNotifierActivationState: true)
        return vm
    }
    
    
    var content: (text: String, attribute: ReminderLabelTextAttribute) {
        
        if reminder.content.isEmpty == true {
            
            return (text: "Enter reminder note", attribute: ReminderLabelTextAttribute.init(withFont: UIFont.systemFont(ofSize: 17.0), color: UIColor.lightGray))
        }
        else {
            return (text: reminder.content, attribute: ReminderLabelTextAttribute.init(withFont: UIFont.systemFont(ofSize: 17.0), color: UIColor.black))
        }
        
    }
    
    var locationDetail: (text: String, attribute: ReminderLabelTextAttribute) {
        
        if reminder.locationString.isEmpty == true {
            
            return (text: "Enter location", attribute: ReminderLabelTextAttribute.init(withFont: UIFont.systemFont(ofSize: 17.0), color: UIColor.lightGray))
        }
        else {
            return (text: reminder.locationString, attribute: ReminderLabelTextAttribute.init(withFont: UIFont.systemFont(ofSize: 17.0), color: UIColor.black))
        }
    }
}
