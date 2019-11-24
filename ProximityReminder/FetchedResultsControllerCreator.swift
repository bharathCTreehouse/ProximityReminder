//
//  FetchedResultsControllerCreator.swift
//  ProximityReminder
//
//  Created by Bharath on 24/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import CoreData


class FetchedResultsControllerCreator {
    
    static func fetchedResultsControllerForReminder(withPredicate predicate: NSPredicate? = nil, propertiesToGet properties: [String]? = nil, sortDescriptors sorters: [NSSortDescriptor]? = nil, inContext context: NSManagedObjectContext, sectionNameKey sectionName: String? = nil) -> NSFetchedResultsController<Reminder> {
        
        let fetchReq: NSFetchRequest<Reminder> = Reminder.createFetchRequest()
        fetchReq.predicate = predicate
        fetchReq.sortDescriptors = sorters
        fetchReq.propertiesToFetch = properties

        if properties?.isEmpty == false {
            fetchReq.resultType = .dictionaryResultType
        }
        else {
            fetchReq.resultType = .managedObjectResultType
        }
        
        let controller: NSFetchedResultsController<Reminder> = NSFetchedResultsController(fetchRequest: fetchReq, managedObjectContext: context, sectionNameKeyPath: sectionName, cacheName: nil)
        return controller
    }
}
