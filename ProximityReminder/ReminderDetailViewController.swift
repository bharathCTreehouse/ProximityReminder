//
//  ReminderDetailViewController.swift
//  ProximityReminder
//
//  Created by Bharath on 25/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ReminderDetailViewController: UIViewController {
    
    private(set) var reminderDetailTableView: ReminderDetailTableView!
    let reminder: Reminder
    var detailViewModel: ReminderDetailViewModel!
    var reminderObserversAdded: Bool = false
    
    lazy private var locationManager: ReminderLocationManager = {
       return ReminderLocationManager(withDelegate: self)
    }()
    
    lazy private var regionIdentifier: String = {
        return reminder.objectID.uriRepresentation().description
    }()
    
    var reminderLocRegion: CLCircularRegion? {
        if let location = reminder.location {
            return CLCircularRegion(center: .init(latitude: location.latitude, longitude: location.longitude), radius: locationManager.monitoringRadius, identifier: regionIdentifier)
        }
        else {
            return nil
        }
    }



    
    init(withReminder reminder: Reminder) {
        
        self.reminder = reminder
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureDetailTableView()
        configureNavigationBarButtonItems()
        
    }
    
    
    override func loadView() {
        
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
    }
    
    
    func configureNavigationBarButtonItems() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped(_:)))
    }
    
    
    func configureDetailTableView() {
        
        detailViewModel = ReminderDetailViewModel(withReminder: reminder)
        
        reminderDetailTableView = ReminderDetailTableView(withDetailSource: detailViewModel, contentTextViewDelegate: self, activationActionDelegate: self, tapCompletion: { [unowned self] (tappedIndexPath: IndexPath) -> Void in
            
            let locationSelectionVC: ReminderLocationSelectionViewController = ReminderLocationSelectionViewController(withReminder: self.reminder)
            
            //Observe changes to reminder notifier type.
            self.reminder.addObserver(self, forKeyPath: "notifierType", options: .new, context: nil)
            
            //Observe changes to reminder location.
            self.reminder.addObserver(self, forKeyPath: "location", options: .new, context: nil)
            
            self.reminderObserversAdded = true
            
            self.navigationController?.pushViewController(locationSelectionVC, animated: true)
        })
        
        view.addSubview(reminderDetailTableView)
        
        reminderDetailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        reminderDetailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        reminderDetailTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        reminderDetailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "location" || keyPath == "notifierType" {
            reminderDetailTableView.refreshLocationContent()
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
   
    
    deinit {
        
        if reminderObserversAdded == true {
            reminder.removeObserver(self, forKeyPath: "location")
            reminder.removeObserver(self, forKeyPath: "notifierType")
        }
        reminderDetailTableView = nil
    }

}



extension ReminderDetailViewController {
    
    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        
        view.endEditing(true)
        
        if CoreDataContextConfigurer.unsavedChangesExistOnMainContext() == false {
            
            //No unsaved changes present. So just dismiss.
            dismiss(animated: true, completion: nil)
            
        }
        else {
            
            //There are unsaved changes present.
            //Ask user what he wishes to do with it.
            
            displayAlertController(withStyle: .actionSheet, alertHeading: ReminderAlertHeading(withTitle: "There are unsaved changes. What do you wish to do with them?"), alertAction: ReminderAlertAction(withDefaultActionTitles: ["Save"], destructiveActionTitles: ["Discard"], cancelTitle: "Cancel"), actionTapHandler: { [unowned self] (actionIdx: Int) -> Void in
                
                if actionIdx == 0 {
                    
                    //Save
                    //Update last modified date.
                    self.reminder.lastModifiedDate = Date()
                    
                    do {
                        //Force save, since check already performed before getting to this place.
                        try CoreDataContextConfigurer.saveChangesPresentInMainContext(forceSave: true)
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    catch  {
                        //Show save failure error.
                    }
                }
                    
                else if actionIdx == 1 {
                    
                    //Discard
                    CoreDataContextConfigurer.discardChangesOnMainContext()
                    self.dismiss(animated: true, completion: nil)
                    
                }
            })
        }
    }
    
    
    @objc func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        view.endEditing(true)
        
        if CoreDataContextConfigurer.unsavedChangesExistOnMainContext() == true {
            
            reminder.lastModifiedDate = Date()
            
            do {
                //ok to force save here. Unsaved data check already performed before getting here.
                try CoreDataContextConfigurer.saveChangesPresentInMainContext(forceSave: true)
                handleReminderActivationState()
                dismiss(animated: true, completion: nil)
                
            }
            catch {
                //Show save failure error
            }
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
}


extension ReminderDetailViewController: ReminderLocationManagerDelegate {
    
    
    /*func beginRegionMonitoring() {
        
        let regionIdentifier: String = reminder.objectID.uriRepresentation().description
        
        if let lat = reminder.location?.latitude, let longi = reminder.location?.longitude {
            
            let regionToMonitor: CLCircularRegion = CLCircularRegion(center: .init(latitude: lat, longitude: longi), radius: .greatestFiniteMagnitude, identifier: regionIdentifier)
            
            let notifier: ReminderNotifier = ReminderNotifier(rawValue: Int(reminder.notifierType))!
            
            if notifier == .entry {
                regionToMonitor.notifyOnEntry = true
            }
            else if notifier == .exit {
                regionToMonitor.notifyOnExit = true
            }
           
            locationManager.startMonitoring(regionToMonitor)
            
        }
        
        //let fetchReq: NSFetchRequest = Reminder.createFetchRequest()
        //fetchReq.predicate = NSPredicate(format: "objectID.uriRepresentation().description == %@", regionIdentifier)
        
    }*/
    
  
    func reactToLocationStatus(_ status: ReminderLocationStatus) {
        
        switch status {
            
            case .monitoringFailedForRegion(region: let failedRegion, error: let err):
                if let failedRegion = failedRegion {
                    print("Err: \(err.localizedDescription)")
                    print("\(failedRegion.identifier)")
            }
            
            case .didEnterMonitoredRegion(region: let enteredRegion): print("Region: \(enteredRegion)")
                configureAndDisplayNotification()
            
            case .didLeaveMonitoredRegion(region: let enteredRegion): print("Region: \(enteredRegion)")
                configureAndDisplayNotification()
            
            default: break
            
        }
        
    }
    
    
    func configureAndDisplayNotification() {
        
            let notificationContent: UNMutableNotificationContent = UNMutableNotificationContent()
            notificationContent.body = reminder.content
            
            var notifierString: String = "Arrived at\n\n"
            if ReminderNotifier(rawValue: Int(reminder.notifierType)) == .exit {
                notifierString = "Leaving \n\n"
            }
            notificationContent.subtitle = notifierString + reminder.location!.address
        
            let notificationTrigger: UNLocationNotificationTrigger = UNLocationNotificationTrigger(region: reminderLocRegion!, repeats: true)
            
            let req: UNNotificationRequest = UNNotificationRequest(identifier: regionIdentifier, content: notificationContent, trigger: notificationTrigger)
            
            let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(req, withCompletionHandler: { (err: Error?) -> Void in
                
                if let err = err {
                    //Could not schedule the notification
                    print("Err: \(err.localizedDescription)")
                }
                else {
                    //Scheduled successfully.
                }
            })
            
        
        
    }
    
}


//TODO: Move this to a separate object, just like the search bar delegate in location search view controller.
extension ReminderDetailViewController: UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if reminder.content.isEmpty == true {
            
            detailViewModel.updateEmptyState(with: .emptyWithEditingBegun)
            reminderDetailTableView.refreshContentView()
        }
        else {
            
            detailViewModel.updateEmptyState(with: .notApplicable)
         reminderDetailTableView.refreshContentViewAppearance()

        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if reminder.content.isEmpty == true {
            
            detailViewModel.updateEmptyState(with: .empty)
            reminderDetailTableView.refreshContentView()
        }
        else {
            
            detailViewModel.updateEmptyState(with: .notApplicable)
            reminderDetailTableView.refreshContentViewAppearance()
            
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        reminder.content = textView.text
    }

}


extension ReminderDetailViewController: ReminderSwitchActionDelegate {
    
    
    func dualModeSwitchDidEndToggle(withCurrentState state: Bool) {
        
        //TODO: KVO this??
        reminder.isActivated = state
        
        //Activation switch toggled. No need to update location. Just refresh the appearance.
        reminderDetailTableView.refreshLocationViewAppearance()
    }
    
    
    
    func handleReminderActivationState() {
        
        if let region = reminderLocRegion {
            
            if reminder.isActivated == false {
                
                //Reminder deactivated.
                
                if locationManager.monitoredRegions(contains: region) == true {
                    
                    //Region was previously being monitored. So stop the notification here.
                    region.notifyOnExit = false
                    region.notifyOnEntry = false
                }
                
            }
            else {
                
                //Reminder activated.
                
                let notifier: ReminderNotifier = ReminderNotifier(rawValue: Int(reminder.notifierType))!
                
                if notifier == .entry {
                    region.notifyOnEntry = true
                    region.notifyOnExit = false
                }
                else if notifier == .exit {
                    region.notifyOnExit = true
                    region.notifyOnEntry = false
                }
                if locationManager.monitoredRegions(contains: region) == false {
                    locationManager.startMonitoring(region)
                    configureAndDisplayNotification()
                }
            }
        }
    }
    
}
