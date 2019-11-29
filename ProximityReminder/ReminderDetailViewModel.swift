//
//  ReminderDetailViewModel.swift
//  ProximityReminder
//
//  Created by Bharath on 26/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


enum ReminderContentEmptyState {
    
    case empty
    case emptyWithEditingBegun
    case notApplicable
    
    var displayText: String? {
        
        switch self {
            case .empty: return "Enter reminder note"
            case .emptyWithEditingBegun: return ""
            default: return nil
        }
    }
    
    var displayTextColor: UIColor {
        
        switch self {
            case .empty: return UIColor.lightGray
            default: return UIColor.black
        }
    }
}

enum ReminderLocationEmptyState {
    
}



class ReminderDetailViewModel {
    
    let reminder: Reminder
    private(set) var contentEmptyState: ReminderContentEmptyState
    
    init(withReminder reminder: Reminder) {
        
        self.reminder = reminder
        if reminder.content.isEmpty == true {
            contentEmptyState = .empty
        }
        else {
            contentEmptyState = .notApplicable
        }
    }
    
    
    func updateEmptyState(with state: ReminderContentEmptyState) {
        
        contentEmptyState = state
    }
}


extension ReminderDetailViewModel: ReminderDetailDisplayable {
    
    var reminderNotifierTypeDetail: (text: String, attribute: ReminderLabelTextAttribute) {
        
        let reminderNotifier: ReminderNotifier = ReminderNotifier(rawValue: Int(reminder.notifierType))!
        
        if reminderNotifier == .undecided {
            
            return (text: "", attribute: ReminderLabelTextAttribute.init(withFont: UIFont.systemFont(ofSize: 17.0), color: UIColor.lightGray))
        }
        else {
            return (text: reminderNotifier.displayString, attribute: ReminderLabelTextAttribute.init(withFont: UIFont.boldSystemFont(ofSize: 17.0), color: UIColor.black))
        }
    }
    
    
    var notifierActivationStatus: ReminderDualModeDisplayable {
        
        let vm = ReminderDetailNotificationActivationViewModel(withNotifierActivationState: reminder.isActivated)
        return vm
    }
    
    
    var content: (text: String, attribute: ReminderLabelTextAttribute) {
        
        if contentEmptyState == .empty {
            
            return (text: contentEmptyState.displayText!, attribute: ReminderLabelTextAttribute.init(withFont: UIFont.systemFont(ofSize: 17.0), color: contentEmptyState.displayTextColor))
        }
        else {
            return (text: reminder.content, attribute: ReminderLabelTextAttribute.init(withFont: UIFont.systemFont(ofSize: 17.0), color: contentEmptyState.displayTextColor))
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
