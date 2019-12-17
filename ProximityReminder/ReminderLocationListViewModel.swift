//
//  ReminderLocationListViewModel.swift
//  ProximityReminder
//
//  Created by Bharath on 01/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderLocationListViewModel: ReminderLocationSearchResultListDisplayable {
    
    private(set) var location: ReminderLocation?
    
    
    init(withLocation location: ReminderLocation?) {
        self.location = location
    }
    
    
    func updateLocation(with loc: ReminderLocation?) {
        location = loc
    }
    
    
    var locationDetail: ReminderSubtitleTextDisplayable {
        
        //Take data from the placemark object and format it.
        
        let subtitleViewModel: ReminderSubtitleTextViewModel = ReminderSubtitleTextViewModel(withSubtitleDetail: (text: formattedAddress, font: UIFont.systemFont(ofSize: 16.0), color: UIColor.black, alpha: 1.0), titleDetail: (text: location?.locationName ?? "", font: UIFont.boldSystemFont(ofSize: 18.0), color: UIColor.black, alpha: 1.0))
        
        return subtitleViewModel
    }
    
    
    deinit {
        location = nil
    }
    
}



extension ReminderLocationListViewModel {
    
    var formattedAddress: String {
        
        return "\(location?.placeMark.subThoroughfare ?? ""), \(location?.placeMark.thoroughfare ?? ""), \(location?.placeMark.subLocality ?? ""), \(location?.placeMark.locality ?? ""), \(location?.placeMark.subAdministrativeArea ?? ""), \(location?.placeMark.administrativeArea ?? ""), \(location?.placeMark.country ?? ""), Postal code: \(location?.placeMark.postalCode ?? "") "
    }

}
