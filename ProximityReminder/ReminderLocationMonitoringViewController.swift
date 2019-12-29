//
//  ReminderLocationMonitoringViewController.swift
//  ProximityReminder
//
//  Created by Bharath Chandrashekar on 24/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderLocationMonitoringViewController: UIViewController, ReminderLocationMonitoringAlertViewControllerDisplayable {
    
    typealias NotifierPresenter = UIViewController
    
    private lazy var alertReminders: [Reminder] = {
        return []
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationMonitoringAlertViewControllerNotificationFired(_:)), name: NSNotification.Name(rawValue: "ReminderLocationMonitoringAlertNotification"), object: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReminderLocationMonitoringAlertNotification"), object: nil)
    }
    
    
    @objc func locationMonitoringAlertViewControllerNotificationFired(_ notification: Notification) {
        
        let reminder: Reminder = notification.userInfo!["reminder"]! as! Reminder
        
        if alertReminders.isEmpty == true {
            
            //No monitoring alert controllers presented thus far.
            
            //Make an attempt to present the alert controller.
            alertUser(aboutReminder: reminder, onPresenter: self)
            
            let alertCont: UIAlertController? = self.presentedViewController as? UIAlertController
            
            if let alertCont = alertCont {
                
                if alertCont.view.tag == LOCATION_MONITORING_ALERT_ID {
                    //Monitoring alert controller successfully presented.
                    //So add the corresponding reminder to the array.
                    alertReminders.append(reminder)
                    
                }
                else {
                    //An alert controller is currently presented. But it is not the monitoring one.
                }
            }
        }
        else {
            //We have already successfully displayed a monitoring alert controller on this view controller. So add the reminder to the waiting list without performing any checks to see if the alert controller can be presented.
            alertReminders.append(reminder)
        }
    }
    
    
    func alertActionTapped(atIndex index: Int, forReminder reminder: Reminder) {
        
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
        //Remove reminder from the array after the corresponding monitoring alert controller has been dismissed.
        alertReminders.removeAll(where: { (rem: Reminder) -> Bool in
            return rem.identifier == reminder.identifier
        })
        
        if alertReminders.isEmpty == false {
            //There are some more queued up reminders that needs to be displayed. So go right ahead and do it one by one.
            let reminder: Reminder = alertReminders.last!
            alertUser(aboutReminder: reminder, onPresenter: self)
        }
    }
    
    
}
