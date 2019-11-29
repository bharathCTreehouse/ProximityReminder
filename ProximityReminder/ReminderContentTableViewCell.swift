//
//  ReminderContentTableViewCell.swift
//  ProximityReminder
//
//  Created by Bharath on 25/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class ReminderContentTableViewCell: UITableViewCell {
    
    @IBOutlet private(set) var reminderContentTextView: UITextView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    //To update text and appearance
    func update(withContentDetail detail: (String, ReminderLabelTextAttribute)) {
        
        updateContentTextViewAppearance(usingAttributeDetail: detail.1)
        reminderContentTextView.text = detail.0
    }
    
    
    //To update only appearance
    func updateContentTextViewAppearance(usingAttributeDetail attr: ReminderLabelTextAttribute) {
        
        reminderContentTextView.font = attr.labelTextFont
        reminderContentTextView.textColor = attr.labelTextColor
    }
    
    
    //To update only text
    func updateContentTextView(withText text: String) {
        
        reminderContentTextView.text = text
    }
    
    
    func assignContentTextViewDelegate(to textViewDelegate: UITextViewDelegate?) {
        
        reminderContentTextView.delegate = textViewDelegate
    }
    
    
    deinit {
        reminderContentTextView = nil
    }
    
}
