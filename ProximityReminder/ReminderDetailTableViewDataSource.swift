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
    
    weak private(set) var reminderActivationActionDelegate: ReminderSwitchActionDelegate! = nil
    
    
    init(withDetailDataSource dataSource: ReminderDetailDisplayable, contentDelegate: UITextViewDelegate?, activationDelegate: ReminderSwitchActionDelegate) {
        
        reminderDetailDisplayable = dataSource
        contentTextViewDelegate = contentDelegate
        reminderActivationActionDelegate = activationDelegate
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
            
            contentCell.update(withContentDetail: reminderDetailDisplayable.content.titleTextDetail)
            
            contentCell.assignContentTextViewDelegate(to: contentTextViewDelegate)
            
            return contentCell
        }
        else {
            
            //Activation status AND Location details
            
            if indexPath.row == 0 {
                
                //Activation status
                
                let activationCell: ReminderSwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reminderActivationCell", for: indexPath) as! ReminderSwitchTableViewCell
                activationCell.assignSwitchActionDelegate(to: reminderActivationActionDelegate)
                activationCell.update(withDualModeDisplayableData: reminderDetailDisplayable.notifierActivationStatus)
                
                return activationCell
            }
            else {
                
                //Location detail
                
                let locationDetailCell: ReminderLocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! ReminderLocationTableViewCell
                locationDetailCell.update(notifierTypeWith: reminderDetailDisplayable.reminderNotifierTypeDetail.titleTextDetail)
                
                locationDetailCell.update(locationWith: reminderDetailDisplayable.locationDetail.titleTextDetail)
                
                return locationDetailCell
            }
        }
        
    }
    
    deinit {
        contentTextViewDelegate = nil
        reminderActivationActionDelegate = nil
    }
}


extension ReminderDetailTableViewDataSource {
    
    func updateContentTextViewAppearance(forTableView tableView: ReminderDetailTableView ) {
        
        let cell: ReminderContentTableViewCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ReminderContentTableViewCell
        
        cell.updateContentTextViewAppearance(usingAttributeDetail: reminderDetailDisplayable.content.titleTextDetail.attribute)
    }
    
    
    func updateContentTextViewText(forTableView  tableView: ReminderDetailTableView) {
        
        let cell: ReminderContentTableViewCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ReminderContentTableViewCell
        
        cell.updateContentTextView(withText: reminderDetailDisplayable.content.titleTextDetail.text)
    }
    
    
    func updateLocationCellAppearance(inTableView tableView: ReminderDetailTableView) {
        
        let cell: ReminderLocationTableViewCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 1)) as! ReminderLocationTableViewCell
        
        cell.updateLocationDetailAlpha(using: reminderDetailDisplayable.locationDetail.titleTextDetail.attribute)
        
        cell.updateNotifierDetailAlpha(using: reminderDetailDisplayable.reminderNotifierTypeDetail.titleTextDetail.attribute)
        
    }
    
    func updateLocationDetail(inTableView tableView: ReminderDetailTableView) {
        
        let indexPath: IndexPath = IndexPath.init(row: 1, section: 1)
        
        let cell: ReminderLocationTableViewCell = tableView.cellForRow(at: indexPath) as! ReminderLocationTableViewCell
        
        //Update location text
        cell.update(locationWith: reminderDetailDisplayable.locationDetail.titleTextDetail)
        
        //Update notifier text
        cell.update(notifierTypeWith: reminderDetailDisplayable.reminderNotifierTypeDetail.titleTextDetail)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
}


