//
//  ReminderListViewController.swift
//  ProximityReminder
//
//  Created by Bharath on 23/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData


class ReminderListViewController: UIViewController {
    
    var reminderListTableView: ReminderListTableView!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetchAllReminderData()
    }
    
    
    func configureReminderListTableView(withFetchedResultsController controller: NSFetchedResultsController<Reminder>) {
        
        reminderListTableView = ReminderListTableView(withFetchedResultsController: controller)
        view.addSubview(reminderListTableView)
        reminderListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        reminderListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        reminderListTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        reminderListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func fetchAllReminderData() {
        
        let sorter: NSSortDescriptor = NSSortDescriptor.init(key: "lastModifiedDate", ascending: false)
        
        let fetchedResultsController: NSFetchedResultsController<Reminder> = FetchedResultsControllerCreator.fetchedResultsControllerForReminder(withPredicate: nil, propertiesToGet: nil, sortDescriptors: [sorter], inContext: CoreDataContextConfigurer.mainContext(), sectionNameKey: "lastModifiedDate")
            
        
        do {
            
            try fetchedResultsController.performFetch()
            
            //Reload tableView to show all the reminders
            if reminderListTableView == nil {
                
               //Table view not configured. So first configure.
                configureReminderListTableView(withFetchedResultsController: fetchedResultsController)
            }
            else {
                reminderListTableView.reloadData()
            }
        }
        catch(let err as NSError) {
            print("Failed to fetch all reminders: \(err.localizedDescription)")
        }
    }
    
    
}

