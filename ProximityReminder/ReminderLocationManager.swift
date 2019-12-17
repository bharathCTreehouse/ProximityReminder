//
//  ReminderLocationManager.swift
//  ProximityReminder
//
//  Created by Bharath Chandrashekar on 14/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import CoreLocation


enum ReminderLocationStatus {
    case locationAccessRequested
    case locationAccessGranted
    case locationAccessRejected
    case didStartFetchingCurrentLocation
    case currentLocationFetched(location: CLLocation)
    case failedToFetchCurrentLocation
    case didEndFetchingCurrentLocation
    case didStartMonitoringRegion(region: CLRegion)
    case didEndMonitoringRegion(region: CLRegion)
}


protocol ReminderLocationManagerDelegate: class {
    func reactToLocationStatus(_ status: ReminderLocationStatus)
}


class ReminderLocationManager: NSObject {
    
    private lazy var manager: CLLocationManager = {
        let locManager = CLLocationManager()
        locManager.delegate = self
        return locManager
    }()
    
    weak private var locationManagerDelegate: ReminderLocationManagerDelegate? = nil
    
    
    required init(withDelegate delegate: ReminderLocationManagerDelegate? = nil) {
        locationManagerDelegate = delegate
    }
    
    
    func fetchCurrentLocation() {
        
        if CLLocationManager.authorizationStatus() == .notDetermined  {
            
            locationManagerDelegate?.reactToLocationStatus( .locationAccessRequested)
            manager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            locationManagerDelegate?.reactToLocationStatus( .didStartFetchingCurrentLocation)
            manager.startUpdatingLocation()
        }
    }
    
    
    
    func stopFetchingCurrentLocation() {
        locationManagerDelegate?.reactToLocationStatus( .didEndFetchingCurrentLocation)
        manager.stopUpdatingLocation()
    }
    
    
    deinit {
        locationManagerDelegate = nil
    }
}



extension ReminderLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.isEmpty == false {
            locationManagerDelegate?.reactToLocationStatus( .currentLocationFetched(location: locations.last!))
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManagerDelegate?.reactToLocationStatus( .locationAccessGranted)
            fetchCurrentLocation()
        }
        else {
            locationManagerDelegate?.reactToLocationStatus( .locationAccessRejected)
        }
        
    }
}
