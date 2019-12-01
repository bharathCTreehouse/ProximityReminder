//
//  Reminder+CoreDataClass.swift
//  ProximityReminder
//
//  Created by Bharath on 24/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//
//

import Foundation
import CoreData


@objc(Reminder)
public class Reminder: NSManagedObject {
    
    
    @objc var lastModifiedDateSansTime: String {
        
        let df: DateFormatter = ReminderDateFormatConfigurer.dateFormatter(withDateStyle: .full, timeStyle: .none)
        
        return df.string(from: lastModifiedDate)
    }

}
