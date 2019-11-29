//
//  ReminderAlertHeading.swift
//  ProximityReminder
//
//  Created by Bharath on 29/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


struct ReminderAlertHeading {
    
    let alertTitle: String?
    let alertMessage: String?
    
    init(withTitle title: String? = nil, message: String? = nil) {
        
        alertTitle = title
        alertMessage = message
    }
    
   
}
