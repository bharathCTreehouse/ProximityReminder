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
    case unknownError
    
    var displayableMessage: String {
        switch self {
            case .saveFailure: return "Failed to save changes to disk. Please verify all the fields and try again."
            case .stackCreationFailure: return "Failed to setup local database. Please reinstall the app and try again."
            default: return "An unknown error has occurred. Please try again."
        }
    }
}


class CoreDataContextConfigurer {
    
    static private var defaultContext: NSManagedObjectContext!
    
    
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
    
    
    static func saveChangesPresentInMainContext(forceSave force: Bool = false) throws {
        
        if defaultContext == nil {
            defaultContext = mainContext()
            //The context itself was nil, so no point attempting a save.
        }
        else {
            
            if force == true {
                
                //Do not perform hasChanges check.
                
                do {
                    try saveMainContext()
                }
                catch {
                    throw ReminderCoreDataError.saveFailure
                }
            }
            else {
                
                //Check if unsaved data present before proceeding to save.
                if unsavedChangesExistOnMainContext() == true {
                    
                    do {
                        try saveMainContext()
                    }
                    catch {
                        throw ReminderCoreDataError.saveFailure

                    }
                }
            }
        }
        
    }
    
    
    private static func saveMainContext() throws {
        
        do {
            try defaultContext.save()
        }
        catch {
            throw ReminderCoreDataError.saveFailure
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
