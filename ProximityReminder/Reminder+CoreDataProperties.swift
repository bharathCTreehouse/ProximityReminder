//
//  Reminder+CoreDataProperties.swift
//  ProximityReminder
//
//  Created by Bharath Chandrashekar on 25/12/19.
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
    @NSManaged public var notifierType: Int16
    @NSManaged public var identifier: String
    @NSManaged public var location: Location?

}
