//
//  ReminderDualModeDisplayable.swift
//  ProximityReminder
//
//  Created by Bharath on 25/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol ReminderDualModeDisplayable {
    
    var dualModeDescription: (text: String, attribute: ReminderLabelTextAttribute) { get }
    var activationDetail: (isActive: Bool, selectionColor: UIColor) { get }
}
