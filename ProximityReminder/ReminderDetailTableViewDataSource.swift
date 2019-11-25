//
//  ReminderDetailTableViewDataSource.swift
//  ProximityReminder
//
//  Created by Bharath on 25/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderDetailTableViewDataSource: NSObject, UITableViewDataSource {
    
    let reminderDetailDisplayable: ReminderDetailDisplayable!
    
    
    init(withDetailDataSource dataSource:ReminderDetailDisplayable ) {
        
        reminderDetailDisplayable = dataSource
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else {
            return 2
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            //Reminder content
            
            let contentCell: ReminderContentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reminderContentCell", for: indexPath) as! ReminderContentTableViewCell
            contentCell.update(withContentDetail: reminderDetailDisplayable.content)
            return contentCell
        }
        else {
            
            //Activation status AND Location details
            
            if indexPath.row == 0 {
                
                //Activation status
                
                let activationCell: ReminderSwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reminderActivationCell", for: indexPath) as! ReminderSwitchTableViewCell
                activationCell.update(withDualModeDisplayableData: reminderDetailDisplayable.notifierActivationStatus)
                
                return activationCell
            }
            else {
                
                //Location detail
                
                let locationDetailCell: ReminderLocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! ReminderLocationTableViewCell
                locationDetailCell.update(notifierTypeWith: reminderDetailDisplayable.notifierTypeDetail)
                locationDetailCell.update(locationWith: reminderDetailDisplayable.locationDetail)
                return locationDetailCell
            }
        }
        
    }
    
    
}
