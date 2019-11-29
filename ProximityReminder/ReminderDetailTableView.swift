//
//  ReminderDetailTableView.swift
//  ProximityReminder
//
//  Created by Bharath on 25/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderDetailTableView: UITableView {
    
    var detailDataSource: ReminderDetailTableViewDataSource! = nil
    
    init(withDetailSource detailSource: ReminderDetailDisplayable, contentTextViewDelegate txtViewDelegate: UITextViewDelegate?) {
        
        super.init(frame: .zero, style: .grouped)
        translatesAutoresizingMaskIntoConstraints = false
        
        detailDataSource = ReminderDetailTableViewDataSource(withDetailDataSource: detailSource, contentDelegate: txtViewDelegate)
        self.dataSource = detailDataSource
        self.delegate = detailDataSource
        
        configure()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        
        
        //For the content of the reminder
        register(UINib.init(nibName: "ReminderContentTableViewCell", bundle: .main), forCellReuseIdentifier: "reminderContentCell")
        
        //Activation status of the notifier
        register(ReminderSwitchTableViewCell.classForCoder(), forCellReuseIdentifier: "reminderActivationCell")
        
        //location
        register(UINib.init(nibName: "ReminderLocationTableViewCell", bundle: .main), forCellReuseIdentifier: "locationCell")
    }
    
    
    
    func refreshContentViewAppearance() {
        
        
        detailDataSource.updateContentTextViewAppearance(forTableView: self)
        
    }
    
    
    func refreshContentTextViewText() {
        detailDataSource.updateContentTextViewText(forTableView: self)
    }
    
    
    func refreshContentView() {
        refreshContentViewAppearance()
        refreshContentTextViewText()
    }
    
}
