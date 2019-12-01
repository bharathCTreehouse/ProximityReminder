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
    
    let locationSelectionDataSource: ReminderLocationSelectionTableViewDataSource!
    
    
    init() {
        locationSelectionDataSource = ReminderLocationSelectionTableViewDataSource()
        super.init(frame: .zero, style: .plain)
        dataSource = locationSelectionDataSource
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
