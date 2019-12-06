//
//  ReminderLocationListTableViewCell.swift
//  ProximityReminder
//
//  Created by Bharath on 07/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderLocationListTableViewCell: UITableViewCell {
    
    weak private(set) var titleSubtitleView: ReminderTitleSubtitleView!

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryType = .checkmark
        accessoryView = UIButton.init(type: .infoLight)
        addDetailView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addDetailView() {
        
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
    
    
    func updateLocationName(with nameDetail: (text: String, attribute: ReminderLabelTextAttribute)) {
        
        titleSubtitleView.update(titleLabelWith: nameDetail)
    }
    
    
    func updateLocationAddress(with addrDetail: (text: String, attribute: ReminderLabelTextAttribute)) {
        
        titleSubtitleView.update(subtitleLabelWith: addrDetail)
    }
    
    
    deinit {
        titleSubtitleView = nil
    }
}
