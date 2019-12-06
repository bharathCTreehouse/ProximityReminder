//
//  ReminderLocationSearchResultListDisplayable.swift
//  ProximityReminder
//
//  Created by Bharath on 05/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol ReminderLocationSearchResultListDisplayable {
    
    //var locationName: (text: String, attribute: ReminderLabelTextAttribute) { get }
    //var otherLocationDetail: (text: String, attribute: ReminderLabelTextAttribute) { get }
    
    var locationDetail: ReminderSubtitleTextDisplayable { get }

}
