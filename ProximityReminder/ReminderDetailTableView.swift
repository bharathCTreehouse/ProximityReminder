//
//  ReminderDetailTableView.swift
//  ProximityReminder
//
//  Created by Bharath on 25/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderDetailTableView: UITableView {
    
    
    init(withDetailSource detailSource: ReminderDetailDisplayable) {
        
        super.init(frame: .zero, style: .grouped)
        translatesAutoresizingMaskIntoConstraints = false
        configure()
        
        let detailDataSource = ReminderDetailTableViewDataSource(withDetailDataSource: detailSource)
        self.dataSource = detailDataSource
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        
        estimatedRowHeight = 50.0
        rowHeight = UITableView.automaticDimension
        
        //For the content of the reminder
        register(UINib.init(nibName: NSStringFromClass(ReminderContentTableViewCell.classForCoder()), bundle: .main), forCellReuseIdentifier: "reminderContentCell")
        
        //Activation status of the notifier
        register(ReminderSwitchTableViewCell.classForCoder(), forCellReuseIdentifier: "reminderActivationCell")
        
        //location
        register(ReminderLocationTableViewCell.classForCoder(), forCellReuseIdentifier: "locationCell")
    }
    
}
