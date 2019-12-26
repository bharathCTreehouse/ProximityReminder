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


class ReminderDetailViewModel {
    
    let reminder: Reminder
    private(set) var contentEmptyState: ReminderContentEmptyState
    
    var alphaValue: CGFloat {
        return (reminder.isActivated == true) ? 1.0 : 0.4
    }
    
    
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
    
    var reminderNotifierTypeDetail: ReminderTitleTextDisplayable {
        
        let reminderNotifier: ReminderNotifier = ReminderNotifier(rawValue: Int(reminder.notifierType))!
        
        if reminderNotifier == .undecided {
            
            return ReminderTitleTextViewModel(withText: "", font: UIFont.systemFont(ofSize: 17.0), color: UIColor.lightGray)
        }
        else {
            
            return ReminderTitleTextViewModel(withText: reminderNotifier.displayString, font: UIFont.boldSystemFont(ofSize: 17.0), color: UIColor.black, alpha: alphaValue)
        }
        
    }
    
    
    var notifierActivationStatus: ReminderDualModeDisplayable {
        
        let vm = ReminderDetailNotificationActivationViewModel(withNotifierActivationState: reminder.isActivated)
        return vm
    }
    
    
    var content: ReminderTitleTextDisplayable {
        
        if contentEmptyState == .empty {
            
            return ReminderTitleTextViewModel(withText: contentEmptyState.displayText!, font: UIFont.systemFont(ofSize: 17.0), color: contentEmptyState.displayTextColor)
        }
        else {
            return ReminderTitleTextViewModel(withText: reminder.content, font: UIFont.systemFont(ofSize: 17.0), color: contentEmptyState.displayTextColor)
        }
    }
    
    
    var locationDetail: ReminderTitleTextDisplayable {
        
        if reminder.location == nil {
            
            return ReminderTitleTextViewModel(withText: "Enter location", font: UIFont.systemFont(ofSize: 17.0), color: UIColor.lightGray)
        }
        else {
            
            return ReminderTitleTextViewModel(withText: reminder.location?.address ?? "", font: UIFont.systemFont(ofSize: 17.0), color: UIColor.black, alpha: alphaValue)
            
            
        }
    }
}
