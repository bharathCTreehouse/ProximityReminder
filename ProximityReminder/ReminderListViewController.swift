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


class ReminderListViewController: ReminderLocationMonitoringViewController {
    
    var reminderListTableView: ReminderListTableView!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureNavigationBarButtonItems()
        fetchAllReminderData()
        requestNotificationPermission()
    }
    
    
    func configureReminderListTableView(withFetchedResultsController controller: NSFetchedResultsController<Reminder>) {
        
        
        reminderListTableView = ReminderListTableView(withFetchedResultsController: controller, reminderTapHandler: { [unowned self] (tappedReminder: Reminder, reason: ReminderTapMotive) -> Void in
            
            if reason == .viewing {
                self.presentDetailViewController(forReminder: tappedReminder)
            }
            else if reason == .deletion {
                self.alertUserAboutDeletion(ofReminder: tappedReminder)
            }
        })
        view.addSubview(reminderListTableView)
        
        reminderListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        reminderListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        reminderListTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        reminderListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func configureNavigationBarButtonItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(createNewReminderButtonTapped(_:)))
    }
    
    
    @objc func createNewReminderButtonTapped(_ sender: UIBarButtonItem) {
        
        let newReminder: Reminder = Reminder.init(context: CoreDataContextConfigurer.mainContext())
        newReminder.lastModifiedDate = Date()
        newReminder.identifier = newReminder.objectID.uriRepresentation().description
        presentDetailViewController(forReminder: newReminder)
    }
    
    
    func presentDetailViewController(forReminder reminder: Reminder) {
        
        let reminderDetailVC: ReminderDetailViewController = ReminderDetailViewController(withReminder: reminder)
        
        let navController: UINavigationController = UINavigationController(rootViewController: reminderDetailVC)
        present(navController, animated: true, completion: nil)
        
    }
    
    
    func alertUserAboutDeletion(ofReminder reminder: Reminder) {
        
        self.displayAlertController(withStyle: .alert, alertHeading: .init(withTitle: "Are you sure you want to delete this Reminder?", message: "Please note you will stop receiving monitoring notifications for this reminder on confirmation."), alertAction: .init(withDefaultActionTitles: [], destructiveActionTitles: ["YES"], cancelTitle: "NO"), actionTapHandler: { (actionIdx: Int) -> Void in
            
            if actionIdx == 0 {
                
                //Delete
                
                CoreDataContextConfigurer.mainContext().delete(reminder)
                
                
                do {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.identifier])
                    
                    let remLocManager: ReminderLocationManager = ReminderLocationManager()
                    
                    if let region = remLocManager.monitoredRegion(withIdentifier: reminder.identifier) {
                        
                        remLocManager.stopMonitoring(region)
                        
                        try CoreDataContextConfigurer.saveChangesPresentInMainContext()

                    }
                }
                catch {
                    //Could not save.
                }
            }
            
        })
        
    }
    
    
    func requestNotificationPermission() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted: Bool, err: Error?) -> Void in
            
            if granted == true && err == nil {
                print("Thanks dude!!!")
            }
            else {
                
            }
        })

        
    }
    
    
    deinit {
        reminderListTableView = nil
    }
}



extension ReminderListViewController: NSFetchedResultsControllerDelegate {
    
    
    func fetchAllReminderData() {
        
        let sorter: NSSortDescriptor = NSSortDescriptor.init(key: "lastModifiedDate", ascending: false)
        
        let fetchedResultsController: NSFetchedResultsController<Reminder> = FetchedResultsControllerCreator.fetchedResultsControllerForReminder(withPredicate: nil, propertiesToGet: nil, sortDescriptors: [sorter], inContext: CoreDataContextConfigurer.mainContext(), sectionNameKey: "lastModifiedDateSansTime")
        
        fetchedResultsController.delegate = self
        
        
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
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        //reminderListTableView.beginUpdates()
        
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        //reminderListTableView.reloadData()

    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        reminderListTableView.reloadData()
        
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        //reminderListTableView.endUpdates()
        
    }
}

