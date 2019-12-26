//
//  ReminderListTableViewDataSource.swift
//  ProximityReminder
//
//  Created by Bharath on 24/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ReminderListTableViewDataSource: NSObject, UITableViewDataSource {
    
    private(set) var fetchedController: NSFetchedResultsController<Reminder>!
    
    
    init(withFetchedResultsController controller: NSFetchedResultsController<Reminder> ) {
        
        fetchedController = controller
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedController.sections?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let secInfo: NSFetchedResultsSectionInfo? = fetchedController.sections?[section]
        return secInfo?.name ?? ""
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  fetchedController.sections?[section].numberOfObjects ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reminder: Reminder = fetchedController.object(at: indexPath)
        let reminderListViewModel: ReminderListViewModel = ReminderListViewModel(withReminder: reminder)
        
        let reminderListCell: ReminderListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reminderListCell", for: indexPath) as! ReminderListTableViewCell
        reminderListCell.update(withReminderListDataSource: reminderListViewModel)
        
        return reminderListCell
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let reminder: Reminder = fetchedController.object(at: indexPath)
            let listTableView: ReminderListTableView = tableView as! ReminderListTableView
            listTableView.reminderTappedHandler(reminder, .deletion)

        }
    }

    
    
    deinit {
        fetchedController = nil
    }
    
}
