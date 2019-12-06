//
//  ReminderInformationDisplayable.swift
//  ProximityReminder
//
//  Created by Bharath on 24/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit

protocol ReminderInformationDisplayable {
    var content: ReminderTitleTextDisplayable { get }
    var locationDetail: ReminderTitleTextDisplayable { get }
    var reminderNotifierTypeDetail: ReminderTitleTextDisplayable { get }
}
