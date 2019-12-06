//
//  ReminderTitleTextDisplayable.swift
//  ProximityReminder
//
//  Created by Bharath on 05/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol ReminderTitleTextDisplayable {
    var titleTextDetail: (text: String, attribute: ReminderLabelTextAttribute) { get }
}
