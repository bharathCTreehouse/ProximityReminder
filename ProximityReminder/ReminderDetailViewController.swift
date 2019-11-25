//
//  ReminderDetailViewController.swift
//  ProximityReminder
//
//  Created by Bharath on 25/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class ReminderDetailViewController: UIViewController {
    
    private(set) var reminderDetailTableView: ReminderDetailTableView!
    
    let reminder: Reminder
    
    
    init(withReminder reminder: Reminder) {
        
        self.reminder = reminder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if reminderDetailTableView == nil {
            configureDetailTableView()
        }
    }
    
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
    }
    
    
    func configureDetailTableView() {
        
        let detailViewModel: ReminderDetailViewModel = ReminderDetailViewModel(withReminder: reminder)
        
        reminderDetailTableView = ReminderDetailTableView(withDetailSource: detailViewModel)
        view.addSubview(reminderDetailTableView)
        reminderDetailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        reminderDetailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        reminderDetailTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        reminderDetailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}
