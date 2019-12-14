//
//  ReminderActivityStatusDisplayable.swift
//  ProximityReminder
//
//  Created by Bharath on 09/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


enum ReminderActivityStatus {
    case notStarted
    case inProgress
    case finished
}


protocol ReminderActivityStatusDisplayable {
    
    
    var statusInProgressDisplayableDetail: (textDetail: ReminderTitleTextDisplayable, activityIndicatorAttribute: ReminderActivityIndicatorInfo?) { get }
    
    var statusFinishedDisplayableDetail: ReminderSubtitleTextDisplayable { get }
    
    var statusNotStartedDisplayableDetail: ReminderTitleTextDisplayable? { get }
}

