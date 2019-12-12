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
    
//    case notStarted (displayDetail: ReminderTitleTextDisplayable?)
//    case inProgress (displayDetail: ReminderTitleTextDisplayable, activityIndicatorAttribute: ReminderActivityIndicatorInfo?)
//    case finished (displayDetail: ReminderSubtitleTextDisplayable)
    
    case notStarted
    case inProgress
    case finished
}


protocol ReminderActivityStatusDisplayable {
    
    //var activityStatusDetail: (status: ReminderActivityStatus, titleDetail: ReminderTitleTextDisplayable?, subtitleDetail: ReminderSubtitleTextDisplayable?, activityIndicatorAttribute: ReminderActivityIndicatorInfo?) { get }
    
    var statusInProgressDisplayableDetail: (textDetail: ReminderTitleTextDisplayable, activityIndicatorAttribute: ReminderActivityIndicatorInfo?) { get }
    
    var statusFinishedDisplayableDetail: ReminderSubtitleTextDisplayable { get }
    
    var statusNotStartedDisplayableDetail: ReminderTitleTextDisplayable? { get }
}

