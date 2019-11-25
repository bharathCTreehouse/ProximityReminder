//
//  ReminderNotifier.swift
//  ProximityReminder
//
//  Created by Bharath on 25/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


enum ReminderNotifier: Int {
    
    case undecided
    case entry
    case exit
    
    var displayString: String {
        
        switch self {
            case .entry: return "Arriving"
            case .exit: return "Leaving"
            case .undecided: return ""
        }
    }
}
