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
    var content: (text: String, attribute: ReminderLabelTextAttribute) { get }
    var locationDetail: (text: String, attribute: ReminderLabelTextAttribute) { get }
    var reminderNotifierTypeDetail: (text: String, attribute: ReminderLabelTextAttribute) { get }
}
