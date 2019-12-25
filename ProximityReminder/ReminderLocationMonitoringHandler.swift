//
//  ReminderLocationMonitoringHandler.swift
//  ProximityReminder
//
//  Created by Bharath Chandrashekar on 22/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData
import UIKit


class ReminderLocationMonitoringHandler: ReminderLocationManagerDelegate {
    
    var locationManager: ReminderLocationManager! = nil
    
    
    init() {
        locationManager = ReminderLocationManager(withDelegate: self)
    }
    
    
    func reactToLocationStatus(_ status: ReminderLocationStatus) {
        
        switch status {
            case .didEnterMonitoredRegion(region: let region):
                    notifyUser(about: region)
            case .didLeaveMonitoredRegion(region: let region):
                    notifyUser(about: region)
            default: break

        }
    }
    
    
    func notifyUser(about region: CLRegion) {
        
        
        let notificationReminder: Reminder? = self.reminder(withIdentifier: region.identifier)
        
        guard let reminder = notificationReminder else {
            return
        }
        
        if UIApplication.shared.applicationState == .active {
            
            //Just show an alert if the app is active.
            //Post a notification to allow the view controller being displayed to show an alert.
            
            print("Location notification fired!!!")

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReminderLocationMonitoringAlertNotification"), object: nil, userInfo: ["reminder": reminder])
         
        }
        else {
            
            let notifierString: String = (reminder.notifierType == 0) ? "Arrived at\n\n" : "Left \n\n"
            
            let content: UNMutableNotificationContent = UNMutableNotificationContent()
            content.body = reminder.content + "\n" + reminder.location!.address
            content.title = "Monitoring notifier"
            content.subtitle = notifierString
            let request: UNNotificationRequest = UNNotificationRequest(identifier: region.identifier, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error: Error?) -> Void in
                
                if error == nil {
                    //Location scheduled successfully.
                    print("Location scheduled successfully")

                }
                else {
                    //Show an alert that scheduling failed.
                    print("Location not scheduled")
                }
            })
            
        }
        
    }
    
    func reminder(withIdentifier identifier: String) -> Reminder? {
        
        let fetchReq: NSFetchRequest = Reminder.createFetchRequest()
        //fetchReq.predicate = NSPredicate(format: "objectID.(uriRepresentation) == %@", url)
        let context: NSManagedObjectContext = CoreDataContextConfigurer.mainContext()
        fetchReq.fetchLimit = 1
        var rem: Reminder? = nil
        
        //context.performAndWait {
            
            do {
                let allReminders: [Reminder] = try context.fetch(fetchReq)
                if allReminders.isEmpty == false {
                    print("FETCHED!!")
                    rem = allReminders.first!
                }
                else {
                    print("EMPTY")
                }
                
            }
            catch(let err) {
                print("Err: \(err.localizedDescription)")
            }
        //}
        
        return rem
    }
}
