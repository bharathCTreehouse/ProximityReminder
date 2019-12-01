//
//  ReminderViewAttribute.swift
//  ProximityReminder
//
//  Created by Bharath on 28/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderViewAttribute {
    
    private(set) var reminderViewAlpha: CGFloat
    
    init(withAlpha alpha: CGFloat = 1.0) {
        reminderViewAlpha = alpha
    }
    
    func changeAlphaValue(to value: CGFloat) {
        reminderViewAlpha = value
    }
}
