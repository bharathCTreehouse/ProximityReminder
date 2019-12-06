//
//  ReminderSubtitleTextDisplayable.swift
//  ProximityReminder
//
//  Created by Bharath on 05/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol ReminderSubtitleTextDisplayable: ReminderTitleTextDisplayable {
    var subtitleTextDetail: (text: String, attribute: ReminderLabelTextAttribute) { get }
}
