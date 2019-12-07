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
    
    var reminderNotifierTypeDetail: ReminderTitleTextDisplayable {
        
        let notifier: ReminderNotifier = ReminderNotifier(rawValue: Int(reminder.notifierType))!
        
        if notifier == .undecided {
            
            return ReminderTitleTextViewModel(withText: "Unspecified notifier type", font: UIFont.systemFont(ofSize: 15.0), color: UIColor.lightGray)
        }
        else {
            
            return ReminderTitleTextViewModel(withText: notifier.displayString, font: UIFont.systemFont(ofSize: 15.0), color: UIColor.black)
            
            //TODO: If the reminder is not activated, reduce the alpha value.
        }
    }
    
    
    var content: ReminderTitleTextDisplayable {
        
        if reminder.content.isEmpty == true {
            
            return ReminderTitleTextViewModel(withText: "No reminder content", font: UIFont.systemFont(ofSize: 17.0), color: UIColor.lightGray)
        }
        else {
            
            return ReminderTitleTextViewModel(withText: reminder.content, font: UIFont.systemFont(ofSize: 17.0), color: UIColor.darkGray)
            
        }
    }
    
    
    var locationDetail: ReminderTitleTextDisplayable {
        
        if reminder.location == nil {
            
            return ReminderTitleTextViewModel(withText: "No reminder location", font: UIFont.systemFont(ofSize: 15.0), color: UIColor.lightGray)
        }
        else {
            
            return ReminderTitleTextViewModel(withText: reminder.location?.name ?? reminder.location!.address, font: UIFont.systemFont(ofSize: 15.0), color: UIColor.black)

            
            //TODO: If the reminder is not activated, reduce the alpha value.
        }
    }
    
    var lastModifiedDetail: ReminderTitleTextDisplayable {
        
        let lastModifiedTimeString: String = ReminderDateFormatConfigurer.dateFormatter(withDateStyle: .none, timeStyle: .short).string(from: reminder.lastModifiedDate)
        
        return ReminderTitleTextViewModel(withText: lastModifiedTimeString, font: UIFont.italicSystemFont(ofSize: 15.0), color: UIColor.black)
    }
}
