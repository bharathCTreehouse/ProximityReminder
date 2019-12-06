//
//  ReminderLocationSelectionTableViewDataSource.swift
//  ProximityReminder
//
//  Created by Bharath on 01/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderLocationSelectionTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var locationSearchListDisplayables: [ReminderLocationSearchResultListDisplayable]!
    
    
    init(withSearchListDisplayableDataSource dataSource: [ReminderLocationSearchResultListDisplayable]) {
        
        locationSearchListDisplayables = dataSource
    }
    
    
    func update(withListDisplayables displayables: [ReminderLocationSearchResultListDisplayable]) {
        
        locationSearchListDisplayables = displayables
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locationSearchListDisplayables.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let displayableData: ReminderLocationSearchResultListDisplayable = locationSearchListDisplayables[indexPath.row]
        
        let cell: ReminderLocationListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "locationDetailCell", for: indexPath) as! ReminderLocationListTableViewCell
        
        cell.updateLocationName(with: displayableData.locationDetail.titleTextDetail)
        cell.updateLocationAddress(with: displayableData.locationDetail.subtitleTextDetail)
        
        return cell
    }
    
    
}
