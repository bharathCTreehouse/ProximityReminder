//
//  ReminderLocationAnnotation.swift
//  ProximityReminder
//
//  Created by Bharath on 08/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import MapKit


class ReminderLocationAnnotation: NSObject, MKAnnotation {
    
    private let locationCoordinate: CLLocationCoordinate2D
    
    init(withLocationCoordinate coordinate: CLLocationCoordinate2D) {
        locationCoordinate = coordinate
    }
    
    convenience init(withLatitude lat: Double, longitude long: Double) {
        self.init(withLocationCoordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
    }
    
    
    var coordinate: CLLocationCoordinate2D {
        return locationCoordinate
    }
}
