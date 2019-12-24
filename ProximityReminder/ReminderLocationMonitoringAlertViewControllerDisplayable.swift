//
//  ReminderLocationMonitoringAlertViewControllerDisplayable.swift
//  ProximityReminder
//
//  Created by Bharath Chandrashekar on 23/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol ReminderLocationMonitoringAlertViewControllerDisplayable {
    
    associatedtype NotifierPresenter where NotifierPresenter == UIViewController
    
    func alertUser(aboutReminder reminder: Reminder, onPresenter presenter: NotifierPresenter)
}


extension ReminderLocationMonitoringAlertViewControllerDisplayable {
    
   
    func alertUser(aboutReminder reminder: Reminder, onPresenter presenter: NotifierPresenter) {

        let notifierString: String = (reminder.notifierType == 0) ? "Arrived at\n\n" : "Left \n\n"
        
        presenter.displayAlertController(withStyle: .alert, alertHeading: .init(withTitle: "Monitoring notifier", message: "\(notifierString) \(reminder.content)"), alertAction: .init(withDefaultActionTitles: ["OK"], destructiveActionTitles: [], cancelTitle: nil), actionTapHandler: { (actionIdx: Int) -> Void in
            
        })
        
    }
}
