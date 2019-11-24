//
//  CoreDataContextConfigurer.swift
//  ProximityReminder
//
//  Created by Bharath on 24/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import CoreData


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
}
