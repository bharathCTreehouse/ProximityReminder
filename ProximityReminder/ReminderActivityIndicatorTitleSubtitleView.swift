//
//  ReminderActivityIndicatorTitleSubtitleView.swift
//  ProximityReminder
//
//  Created by Bharath on 08/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderActivityIndicatorTitleSubtitleView: UIView {
    
    let viewModel: ReminderActivityStatusDisplayable
    private(set) var activityStatus: ReminderActivityStatus
    
    
    init(withViewModel vm: ReminderActivityStatusDisplayable, activityStatus status: ReminderActivityStatus) {
        
        viewModel = vm
        activityStatus = status
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureSubviews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureSubviews() {
        
    }
    
    
    func changeActivityStatus(to status: ReminderActivityStatus) {
        activityStatus = status
    }
    
}
