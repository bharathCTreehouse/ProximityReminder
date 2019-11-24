//
//  ReminderDetailDisplayable.swift
//  ProximityReminder
//
//  Created by Bharath on 24/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol ReminderDetailDisplayable: ReminderInformationDisplayable {
    
    var notifierTypeDetail: (text: String, attr: ReminderLabelTextAttribute) { get }
    
}
