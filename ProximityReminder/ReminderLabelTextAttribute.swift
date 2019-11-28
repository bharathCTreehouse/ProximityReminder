//
//  ReminderLabelTextAttribute.swift
//  ProximityReminder
//
//  Created by Bharath on 24/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderLabelTextAttribute: ReminderViewAttribute {
    
    let labelTextFont: UIFont
    let labelTextColor: UIColor
    
    init(withFont font: UIFont, color: UIColor, alpha: CGFloat = 1.0) {
        
        labelTextFont = font
        labelTextColor = color
        super.init(withAlpha: alpha)
        
    }
}
