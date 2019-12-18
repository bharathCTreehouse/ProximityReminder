//
//  ReminderCurrentLocationListViewModel.swift
//  ProximityReminder
//
//  Created by Bharath on 09/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderCurrentLocationListViewModel: ReminderLocationListViewModel {
    
    
    override var locationDetail: ReminderSubtitleTextDisplayable {
        
        if location?.locationName != nil {
            return super.locationDetail
        }
        else {
            //When the current location name is not available, we shall show "current location" as the title with a slighly different font and color.
            return  ReminderSubtitleTextViewModel(withSubtitleDetail: (text: formattedAddress, font: UIFont.systemFont(ofSize: 16.0), color: UIColor.black, alpha: 1.0), titleDetail: (text: "Current location", font: UIFont.italicSystemFont(ofSize: 18.0), color: UIColor.black, alpha: 1.0))
            
        }
    }
}


extension ReminderCurrentLocationListViewModel: ReminderActivityStatusDisplayable {
    
    
    var statusInProgressDisplayableDetail: (textDetail: ReminderTitleTextDisplayable, activityIndicatorAttribute: ReminderActivityIndicatorInfo?) {
        
        let titleViewModel: ReminderTitleTextViewModel = ReminderTitleTextViewModel(withText: "Fetching current location ...", font: UIFont.italicSystemFont(ofSize: 17.0), color: UIColor.darkGray)
        
        let indicatorInfo: ReminderActivityIndicatorInfo = ReminderActivityIndicatorInfo(activityIndicatorStyle: .medium, backgroundColor: nil, shouldHideWhenStopped: true)
        
        return (textDetail: titleViewModel, activityIndicatorAttribute: indicatorInfo)
        
    }
    
    var statusFinishedDisplayableDetail: ReminderSubtitleTextDisplayable {
        return locationDetail
    }
    
    var statusNotStartedDisplayableDetail: ReminderTitleTextDisplayable? {
        return nil
    }
}
