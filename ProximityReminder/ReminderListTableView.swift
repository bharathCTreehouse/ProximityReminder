//
//  ReminderListTableView.swift
//  ProximityReminder
//
//  Created by Bharath on 24/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class ReminderListTableView: UITableView {
    
    
    init(withFetchedResultsController controller: NSFetchedResultsController<Reminder>) {
        
        super.init(frame: .zero, style: .grouped)
        translatesAutoresizingMaskIntoConstraints = false
        
        configure()
       
        let dataSource: ReminderListTableViewDataSource = ReminderListTableViewDataSource(withFetchedResultsController: controller)
        self.dataSource = dataSource
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        
        estimatedRowHeight = 60.0
        rowHeight = UITableView.automaticDimension
        register(UINib.init(nibName: NSStringFromClass(ReminderListTableViewCell.classForCoder()), bundle: .main), forCellReuseIdentifier: "reminderListCell")
    }
    
}
