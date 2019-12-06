//
//  ReminderTitleSubtitleView.swift
//  ProximityReminder
//
//  Created by Bharath on 05/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderTitleSubtitleView: UIView {
    
    @IBOutlet private(set) var titleLabel: UILabel!
    @IBOutlet private(set) var subtitleLabel: UILabel!
    
    
    
    func update(titleLabelWith titleDetail: (String, ReminderLabelTextAttribute) ) {
        
        titleLabel.font = titleDetail.1.labelTextFont
        titleLabel.textColor = titleDetail.1.labelTextColor
        titleLabel.text = titleDetail.0
        
        changeTitleLabelAlphaValue(to: titleDetail.1.reminderViewAlpha)
    }
    
    
    func update(subtitleLabelWith subtitleDetail: (String, ReminderLabelTextAttribute) ) {
        
        subtitleLabel.font = subtitleDetail.1.labelTextFont
        subtitleLabel.textColor = subtitleDetail.1.labelTextColor
        subtitleLabel.text = subtitleDetail.0
        
        changeSubtitleLabelAlphaValue(to: subtitleDetail.1.reminderViewAlpha)
    }
    
    
    func changeTitleLabelAlphaValue(to value: CGFloat) {
        titleLabel.alpha = value
    }
    
    
    func changeSubtitleLabelAlphaValue(to value: CGFloat) {
        subtitleLabel.alpha = value
    }
    
    
    deinit {
        
        titleLabel = nil
        subtitleLabel = nil
    }
}
