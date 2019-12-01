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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
}
