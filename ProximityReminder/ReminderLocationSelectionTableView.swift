//
//  ReminderLocationSelectionTableView.swift
//  ProximityReminder
//
//  Created by Bharath on 01/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderLocationSelectionTableView: UITableView {
    
    var locationSelectionDataSource: ReminderLocationSelectionTableViewDataSource! = nil
    
    
    init(withListDisplayables displayables: [ReminderLocationListViewModel]) {
        
        locationSelectionDataSource = ReminderLocationSelectionTableViewDataSource(withSearchListDisplayableDataSource: displayables)
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        register(ReminderLocationListTableViewCell.classForCoder(), forCellReuseIdentifier: "locationDetailCell")
        estimatedRowHeight = 50.0
        rowHeight = UITableView.automaticDimension
        dataSource = locationSelectionDataSource
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    func update(withDisplayables displayables: [ReminderLocationListViewModel]) {
        
        locationSelectionDataSource.update(withListDisplayables: displayables)
        reloadData()
    }
    
}
