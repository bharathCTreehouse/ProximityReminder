//
//  ReminderLocationMonitoringAlertViewControllerDisplayable.swift
//  ProximityReminder
//
//  Created by Bharath Chandrashekar on 23/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


let LOCATION_MONITORING_ALERT_ID: Int = 888


protocol ReminderLocationMonitoringAlertViewControllerDisplayable {
    
    associatedtype NotifierPresenter where NotifierPresenter == UIViewController
    
    func alertUser(aboutReminder reminder: Reminder, onPresenter presenter: NotifierPresenter)
    
    func alertActionTapped(atIndex index: Int, forReminder reminder: Reminder)
}


extension ReminderLocationMonitoringAlertViewControllerDisplayable {
    
   
    func alertUser(aboutReminder reminder: Reminder, onPresenter presenter: NotifierPresenter) {

        let notifierString: String = (reminder.notifierType == 0) ? "ARRIVED" : "LEFT"
        let locationString: String = "\(reminder.location!.address) \n\n"
        
        presenter.displayAlertController(withStyle: .alert, alertHeading: .init(withTitle: notifierString, message: "\(locationString) \(reminder.content)"), alertAction: .init(withDefaultActionTitles: ["OK"], destructiveActionTitles: [], cancelTitle: nil), alertControllerTag: LOCATION_MONITORING_ALERT_ID,  actionTapHandler: {  (actionIdx: Int) -> Void in
            
            self.alertActionTapped(atIndex: actionIdx, forReminder: reminder)
        })
        
    }
}
