//
//  ReminderLocationSelectionTableView.swift
//  ProximityReminder
//
//  Created by Bharath on 01/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


enum ReminderLocationCellTapType {
    
    case locationTapped
    case locationInfoTapped
    case unknown
}


protocol ReminderLocationSelectionResponder: class {
    
    func reactTo(tapType type: ReminderLocationCellTapType, atIndexPath idxPath: IndexPath)
}


class ReminderLocationSelectionTableView: UITableView {
    
    @objc var locationSelectionDataSource: ReminderLocationSelectionTableViewDataSource! = nil
    
    weak private(set) var locationSelectionResponder: ReminderLocationSelectionResponder? = nil
    
    
    init(withListDisplayables displayables: [ReminderLocationListViewModel], selectionResponder responder: ReminderLocationSelectionResponder?) {
        
        locationSelectionResponder = responder
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        
        locationSelectionDataSource = ReminderLocationSelectionTableViewDataSource(withSearchListDisplayableDataSource: displayables, infoButtonTapResponder: self)
        dataSource = locationSelectionDataSource
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        
        register(ReminderLocationListTableViewCell.classForCoder(), forCellReuseIdentifier: "locationDetailCell")
        estimatedRowHeight = 50.0
        rowHeight = UITableView.automaticDimension
        delegate = self
    }
    
 
    func update(withDisplayables displayables: [ReminderLocationListViewModel]) {
        
        locationSelectionDataSource.update(withListDisplayables: displayables)
        reloadData()
    }
    
    
    deinit {
        locationSelectionDataSource = nil
        locationSelectionResponder = nil
    }
    
}


extension ReminderLocationSelectionTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        locationSelectionResponder?.reactTo(tapType: .locationTapped, atIndexPath: indexPath)
    }
}


extension ReminderLocationSelectionTableView: ReminderLocationListTableViewInfoButtonResponder {
    
    func locationInfoButtonTapped(atIndexPath idxPath: IndexPath) {
        
        locationSelectionResponder?.reactTo(tapType: .locationInfoTapped, atIndexPath: idxPath)

    }
}
