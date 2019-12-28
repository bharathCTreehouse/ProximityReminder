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


enum ReminderTapMotive {
    case viewing
    case deletion
}



class ReminderListTableView: UITableView {
    
    var listDataSource: ReminderListTableViewDataSource! = nil
    private(set) var reminderTappedHandler: ((Reminder, ReminderTapMotive) -> Void)! = nil
    
    init(withFetchedResultsController controller: NSFetchedResultsController<Reminder>, reminderTapHandler handler: ((Reminder, ReminderTapMotive) -> Void)?) {
        
        reminderTappedHandler = handler
        super.init(frame: .zero, style: .grouped)
        translatesAutoresizingMaskIntoConstraints = false
        
        configure()
       
        listDataSource = ReminderListTableViewDataSource(withFetchedResultsController: controller)
        dataSource = listDataSource
        delegate = self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        
        estimatedRowHeight = 60.0
        rowHeight = UITableView.automaticDimension
        register(UINib.init(nibName: "ReminderListTableViewCell", bundle: .main), forCellReuseIdentifier: "reminderListCell")
    }
    
    
    deinit {
        listDataSource = nil
        reminderTappedHandler = nil
    }
    
}



extension ReminderListTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let reminder: Reminder = listDataSource.fetchedController.object(at: indexPath)
        reminderTappedHandler(reminder, .viewing)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
