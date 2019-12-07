//
//  Location+CoreDataProperties.swift
//  ProximityReminder
//
//  Created by Bharath on 07/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var address: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var uniqueIdentifier: String
    @NSManaged public var reminder: Reminder

}
