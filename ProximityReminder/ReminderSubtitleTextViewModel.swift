//
//  ReminderSubtitleTextViewModel.swift
//  ProximityReminder
//
//  Created by Bharath on 05/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderSubtitleTextViewModel: ReminderTitleTextViewModel {
    
    let subtitleText: String
    let subtitleFont: UIFont
    let subtitleColor: UIColor
    let subtitleAlphaValue: CGFloat
    
    init(withSubtitleDetail subtitleDetail: (text: String, font: UIFont, color: UIColor, alpha: CGFloat), titleDetail: (text: String, font: UIFont, color: UIColor, alpha: CGFloat) ) {
        
        subtitleText = subtitleDetail.text
        subtitleFont = subtitleDetail.font
        subtitleColor = subtitleDetail.color
        subtitleAlphaValue = subtitleDetail.alpha
        super.init(withText: titleDetail.text, font: titleDetail.font, color: titleDetail.color, alpha: titleDetail.alpha)
    }
    
}


extension ReminderSubtitleTextViewModel: ReminderSubtitleTextDisplayable {
    
    
    var subtitleTextDetail: (text: String, attribute: ReminderLabelTextAttribute) {
        
        return (text: subtitleText, attribute: ReminderLabelTextAttribute(withFont: subtitleFont, color: subtitleColor, alpha: subtitleAlphaValue))
    }
}
