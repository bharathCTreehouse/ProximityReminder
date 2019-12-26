//
//  ReminderArrayUtility.swift
//  ProximityReminder
//
//  Created by Bharath on 03/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import MapKit


extension Array where Element == MKMapItem {
    
    var reminderLocations: [ReminderLocation] {
        
        let locations: [ReminderLocation] = compactMap({ (mapKitItem: MKMapItem) -> ReminderLocation in
            
            return ReminderLocation(withPlaceMark: mapKitItem.placemark, nameOfTheLocation: mapKitItem.name)
        })
        
        return locations
    }
}


extension Array where Element == ReminderLocation {
    
    var reminderLocationListViewModels: [ReminderLocationListViewModel] {
        
        let listViewModels: [ReminderLocationListViewModel] = compactMap({ (location: ReminderLocation) -> ReminderLocationListViewModel in
            
            return ReminderLocationListViewModel(withLocation: location)
        })
        
        return listViewModels
    }
}
