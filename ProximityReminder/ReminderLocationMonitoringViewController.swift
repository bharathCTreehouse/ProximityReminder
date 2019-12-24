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
        alertUser(aboutReminder: reminder, onPresenter: self)
        
    }
    
    
}
