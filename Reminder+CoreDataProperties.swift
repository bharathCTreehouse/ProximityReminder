//
//  Reminder+CoreDataProperties.swift
//  ProximityReminder
//
//  Created by Bharath on 28/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var content: String
    @NSManaged public var isActivated: Bool
    @NSManaged public var lastModifiedDate: Date
    @NSManaged public var locationString: String
    @NSManaged public var notifierType: Int16

}
