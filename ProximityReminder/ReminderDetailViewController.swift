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

class ReminderDetailViewController: ReminderLocationMonitoringViewController {
    
    private(set) var reminderDetailTableView: ReminderDetailTableView!
    private let reminder: Reminder
    private var detailViewModel: ReminderDetailViewModel!
    private var reminderObserversAdded: Bool = false
    
    lazy private var locationManager: ReminderLocationManager = {
       return ReminderLocationManager(withDelegate: self)
    }()
    
   
    var reminderLocRegion: CLCircularRegion? {
        if let location = reminder.location {
            return CLCircularRegion(center: .init(latitude: location.latitude, longitude: location.longitude), radius: locationManager.monitoringRadius, identifier: reminder.identifier)
        }
        else {
            return nil
        }
    }



    
    init(withReminder reminder: Reminder) {
        
        self.reminder = reminder
        super.init(nibName: nil, bundle: nil)
        self.reminder.addObserver(self, forKeyPath: "isActivated", options: .new, context: nil)
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
        
        reminderDetailTableView = ReminderDetailTableView(withDetailSource: detailViewModel, contentTextViewDelegate: self, activationActionDelegate: self, tapCompletion: { [unowned self] (tappedIndexPath: IndexPath?, tapType: ReminderDetailTapType) -> Void in
            
            if tapType == .locationSelection {
                
                let locationSelectionVC: ReminderLocationSelectionViewController = ReminderLocationSelectionViewController(withReminder: self.reminder)
                
                //Observe changes to reminder notifier type.
                self.reminder.addObserver(self, forKeyPath: "notifierType", options: .new, context: nil)
                
                //Observe changes to reminder location.
                self.reminder.addObserver(self, forKeyPath: "location", options: .new, context: nil)
                
                self.reminderObserversAdded = true
                
                self.navigationController?.pushViewController(locationSelectionVC, animated: true)
            }
            else if tapType == .displayLocationOnMap {
                
                //Show the currently set location of the reminder on the map.
                let lat: Double? = self.reminder.location?.latitude
                let longi: Double? = self.reminder.location?.longitude
                
                if let lat = lat, let longi = longi {
                    
                    let mapVC: ReminderLocationMapViewController = ReminderLocationMapViewController(withLocationCoordinate: .init(latitude: lat, longitude: longi), nameOfLocation: self.reminder.location?.name, addressOfLocation: self.reminder.location?.address ?? "", modeOfDismissal: .usingCloseButton)
                    let navController: UINavigationController = UINavigationController.init(rootViewController: mapVC)
                    self.present(navController, animated: true, completion: nil)
                }
            }
        })
        
        view.addSubview(reminderDetailTableView)
        
        reminderDetailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        reminderDetailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        reminderDetailTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        reminderDetailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        handleLocationMapViewAppearance()
    }
    
    
    func handleLocationMapViewAppearance() {
        if reminder.location == nil {
            reminderDetailTableView.enableMapLocationView(false)
        }
        else {
            reminderDetailTableView.enableMapLocationView(true)
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "location" || keyPath == "notifierType" {
            reminderDetailTableView.refreshLocationContent()
            handleLocationMapViewAppearance()
        }
        else if keyPath == "isActivated" {
            //Activation switch toggled. No need to update location. Just refresh the appearance.
            reminderDetailTableView.refreshLocationViewAppearance()
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
        reminder.removeObserver(self, forKeyPath: "isActivated")
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
                    catch (let error as ReminderCoreDataError)  {
                        
                        //Show save failure error
                        
                        self.displayAlertController(withStyle: .alert, alertHeading: .init(withTitle: error.displayableMessage, message: nil), alertAction: .init(withDefaultActionTitles: ["OK"], destructiveActionTitles: [], cancelTitle: nil), actionTapHandler: { (actIdx: Int) -> Void in
                            
                        })
                    }
                    catch {
                        self.displayAlertController(withStyle: .alert, alertHeading: .init(withTitle: ReminderCoreDataError.unknownError.displayableMessage, message: nil), alertAction: .init(withDefaultActionTitles: ["OK"], destructiveActionTitles: [], cancelTitle: nil), actionTapHandler: { (actIdx: Int) -> Void in
                            
                        })
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
            catch (let error as ReminderCoreDataError) {
                
                //Show save failure error
                
                displayAlertController(withStyle: .alert, alertHeading: .init(withTitle: error.displayableMessage, message: nil), alertAction: .init(withDefaultActionTitles: ["OK"], destructiveActionTitles: [], cancelTitle: nil), actionTapHandler: { (actIdx: Int) -> Void in
                    
                })
            }
            catch {
                displayAlertController(withStyle: .alert, alertHeading: .init(withTitle: ReminderCoreDataError.unknownError.displayableMessage, message: nil), alertAction: .init(withDefaultActionTitles: ["OK"], destructiveActionTitles: [], cancelTitle: nil), actionTapHandler: { (actIdx: Int) -> Void in
                    
                })
            }
                
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
}


extension ReminderDetailViewController: ReminderLocationManagerDelegate {
    
    
    func reactToLocationStatus(_ status: ReminderLocationStatus) {
        
        switch status {
            
            case .monitoringFailedForRegion(_ , error: let err):
            
                displayAlertController(withStyle: .alert, alertHeading: .init(withTitle: "Failed to start monitoring", message: err.localizedDescription), alertAction: .init(withDefaultActionTitles: ["OK"], destructiveActionTitles: [], cancelTitle: nil)) { (idx) in
                
                }
            
            
            case .didStartMonitoringRegion(region: let region):
                //Region monitoring has begun successfully.
                print("Region: \(region), monitoring has begun successfully!")
            
            default: break
        }
        
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
        
        //KVO will handle the UI change.
        reminder.isActivated = state
    }
    
    
    
    func handleReminderActivationState() {
        
        if let region = reminderLocRegion {
            
            if reminder.isActivated == false {
                
                //Reminder deactivated.
                
                if locationManager.monitoredRegions(contains: region) == true {
                    
                    //Remove pending local notifications.
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [region.identifier])

                    //Region was previously being monitored. So stop the notification here and stop monitoring too.
                    region.notifyOnExit = false
                    region.notifyOnEntry = false
                    locationManager.stopMonitoring(region)
                }
                
            }
            else {
                
                //Reminder activated.
                
                //Remove pending local notifications.
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [region.identifier])
                
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
                }
                else {
                    locationManager.stopMonitoring(region)
                    locationManager.startMonitoring(region)
                }
            }
        }
    }
    
}
