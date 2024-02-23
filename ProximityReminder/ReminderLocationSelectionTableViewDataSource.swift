//
//  ReminderLocationSelectionTableViewDataSource.swift
//  ProximityReminder
//
//  Created by Bharath on 01/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol ReminderLocationListTableViewInfoButtonResponder: AnyObject {
    func locationInfoButtonTapped(atIndexPath idxPath: IndexPath)
}


class ReminderLocationSelectionTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var locationSearchListDisplayables: [ReminderLocationSearchResultListDisplayable]!
    
    weak private(set) var infoButtonTapResponder: ReminderLocationListTableViewInfoButtonResponder? = nil
    
    
    init(withSearchListDisplayableDataSource dataSource: [ReminderLocationSearchResultListDisplayable], infoButtonTapResponder responder: ReminderLocationListTableViewInfoButtonResponder?) {
        
        locationSearchListDisplayables = dataSource
        infoButtonTapResponder = responder
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
        
        cell.updateIndexPath(with: indexPath, infoTapHandler: { [unowned self] (tappedIdxPath: IndexPath) -> Void in
            self.infoButtonTapResponder?.locationInfoButtonTapped(atIndexPath: tappedIdxPath)
        })
        
        cell.updateLocationName(with: displayableData.locationDetail.titleTextDetail)
        cell.updateLocationAddress(with: displayableData.locationDetail.subtitleTextDetail)
        
        return cell
    }
    
    
    deinit {
        locationSearchListDisplayables = nil
        infoButtonTapResponder = nil
    }
    
    
}
