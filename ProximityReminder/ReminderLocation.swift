//
//  ReminderLocation.swift
//  ProximityReminder
//
//  Created by Bharath on 01/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import CoreLocation


class ReminderLocation {
    
    let placeMark: CLPlacemark
    let locationName: String?
    
    init(withPlaceMark placeMark: CLPlacemark, nameOfTheLocation name: String?) {
        
        self.placeMark = placeMark
        locationName = name
    }
    
}
