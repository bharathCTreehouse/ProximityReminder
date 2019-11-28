//
//  CoreDataContextConfigurer.swift
//  ProximityReminder
//
//  Created by Bharath on 24/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import CoreData

enum ReminderCoreDataError: Error {
    case saveFailure
    case stackCreationFailure
}


class CoreDataContextConfigurer {
    
    static private(set) var defaultContext: NSManagedObjectContext!
    
    
    static func mainContext() -> NSManagedObjectContext {
        
        if defaultContext == nil {
            
            //The stack has not been created yet. So go ahead and create the core data stack first.
            
            let container: NSPersistentContainer = NSPersistentContainer.init(name: "ProximityReminder")
            
            container.loadPersistentStores(completionHandler: { (storeDesc: NSPersistentStoreDescription?, error: Error?) -> Void in
                
                if error == nil {
                    //Stack creation a grand success!
                    defaultContext = container.viewContext
                }
                else {
                    //What do we do with errors?
                }
                
            })
            
        }
        return defaultContext
    }
    
    
    static func saveChangesPresentInMainContext() throws {
        
        if defaultContext == nil {
            defaultContext = mainContext()
            //The context itself was nil, so no point attempting a save.
        }
        else {
            if unsavedChangesExistOnMainContext() == true {
                do {
                    try defaultContext.save()
                }
                catch {
                    throw ReminderCoreDataError.saveFailure
                }
            }
        }
        
    }
    
    
    static func unsavedChangesExistOnMainContext() -> Bool {
        return defaultContext.hasChanges
    }
    
    
    static func discardChangesOnMainContext() {
        
        if defaultContext == nil {
            defaultContext = mainContext()
        }
        else {
            defaultContext.rollback()
        }
    }
}
