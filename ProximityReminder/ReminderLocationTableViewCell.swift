//
//  ReminderLocationTableViewCell.swift
//  ProximityReminder
//
//  Created by Bharath on 26/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class ReminderLocationTableViewCell: UITableViewCell {
    
    weak private(set) var titleSubtitleView: ReminderTitleSubtitleView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addTitleSubtitleView()
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addTitleSubtitleView() {
        
        if titleSubtitleView == nil {
            
            titleSubtitleView = (Bundle.main.loadNibNamed("ReminderTitleSubtitleView", owner: nil, options: nil)?.first as! ReminderTitleSubtitleView)
            titleSubtitleView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(titleSubtitleView)
            titleSubtitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            titleSubtitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            titleSubtitleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            titleSubtitleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
    }
    
    
    func update(notifierTypeWith notifierDetail: (String, ReminderLabelTextAttribute) ) {
        
        titleSubtitleView.update(titleLabelWith: notifierDetail)
    }
    
    
    func update(locationWith locationDetail: (String, ReminderLabelTextAttribute) ) {
        
        titleSubtitleView.update(subtitleLabelWith: locationDetail)
    }
    
    
    func updateLocationDetailAlpha(using attr: ReminderLabelTextAttribute) {
        
        titleSubtitleView.changeSubtitleLabelAlphaValue(to: attr.reminderViewAlpha)
        
    }
    
    
    func updateNotifierDetailAlpha(using attr: ReminderLabelTextAttribute) {
        
        titleSubtitleView.changeTitleLabelAlphaValue(to: attr.reminderViewAlpha)
    }
    
    
    deinit {
        titleSubtitleView = nil
    }
    
}
