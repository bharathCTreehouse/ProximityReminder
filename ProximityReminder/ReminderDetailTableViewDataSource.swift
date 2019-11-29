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
    weak private(set) var contentTextViewDelegate: UITextViewDelegate?
    
    
    init(withDetailDataSource dataSource: ReminderDetailDisplayable, contentDelegate: UITextViewDelegate? ) {
        
        reminderDetailDisplayable = dataSource
        contentTextViewDelegate = contentDelegate
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
            contentCell.selectionStyle = .none
            contentCell.update(withContentDetail: reminderDetailDisplayable.content)
            contentCell.assignContentTextViewDelegate(to: contentTextViewDelegate)
            return contentCell
        }
        else {
            
            //Activation status AND Location details
            
            if indexPath.row == 0 {
                
                //Activation status
                
                let activationCell: ReminderSwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reminderActivationCell", for: indexPath) as! ReminderSwitchTableViewCell
                
                activationCell.selectionStyle = .none
                activationCell.update(withDualModeDisplayableData: reminderDetailDisplayable.notifierActivationStatus)
                
                return activationCell
            }
            else {
                
                //Location detail
                
                let locationDetailCell: ReminderLocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! ReminderLocationTableViewCell
                locationDetailCell.update(notifierTypeWith: reminderDetailDisplayable.reminderNotifierTypeDetail)
                locationDetailCell.update(locationWith: reminderDetailDisplayable.locationDetail)
                return locationDetailCell
            }
        }
        
    }
    
    
    func updateContentTextViewAppearance(forTableView tableView: ReminderDetailTableView ) {
        
        let cell: ReminderContentTableViewCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ReminderContentTableViewCell
        cell.updateContentTextViewAppearance(usingAttributeDetail: reminderDetailDisplayable.content.attribute)
    }
    
    
    func updateContentTextViewText(forTableView  tableView: ReminderDetailTableView) {
        
        let cell: ReminderContentTableViewCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ReminderContentTableViewCell
        
        cell.updateContentTextView(withText: reminderDetailDisplayable.content.text)
    }
    
}


extension ReminderDetailTableViewDataSource: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 150.0
        }
        else {
            return UITableView.automaticDimension
        }
        
    }
}
