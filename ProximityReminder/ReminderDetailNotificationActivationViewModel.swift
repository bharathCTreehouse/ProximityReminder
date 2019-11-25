//
//  ReminderDetailNotificationActivationViewModel.swift
//  ProximityReminder
//
//  Created by Bharath on 25/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderDetailNotificationActivationViewModel {
    
    let activate: Bool
    
    init(withNotifierActivationState isActivated: Bool) {
        activate = isActivated
    }
}


extension ReminderDetailNotificationActivationViewModel: ReminderDualModeDisplayable {
    
    
    var dualModeDescription: (text: String, attribute: ReminderLabelTextAttribute) {
        
        return (text: "Activate reminder", attribute: ReminderLabelTextAttribute.init(withFont: UIFont.systemFont(ofSize: 17.0), color: UIColor.black))
    }
    
    
    var activationDetail: (isActive: Bool, selectionColor: UIColor) {
        
        return (isActive: activate, selectionColor: UIColor.blue)
        
    }
}
