//
//  ReminderListDisplayable.swift
//  ProximityReminder
//
//  Created by Bharath on 24/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol ReminderListDisplayable: ReminderInformationDisplayable {
    
    var lastModifiedDetail: ReminderTitleTextDisplayable { get }

}
