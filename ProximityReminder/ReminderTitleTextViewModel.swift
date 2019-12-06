//
//  ReminderTitleTextViewModel.swift
//  ProximityReminder
//
//  Created by Bharath on 05/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderTitleTextViewModel: ReminderTitleTextDisplayable {
    
    let text: String
    let font: UIFont
    let color: UIColor
    let alphaValue: CGFloat
    
    init(withText text: String, font: UIFont, color: UIColor, alpha: CGFloat = 1.0) {
        
        self.text = text
        self.font = font
        self.color = color
        alphaValue = alpha
    }
    
    var titleTextDetail: (text: String, attribute: ReminderLabelTextAttribute) {
        
        return (text: self.text, attribute: ReminderLabelTextAttribute(withFont: font, color: color, alpha: alphaValue))
    }
    
}
