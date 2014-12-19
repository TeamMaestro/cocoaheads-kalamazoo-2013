//
//  NSManagedObjectContext+Extensions.swift
//  SwiftShopList
//
//  Created by Norm Barnard on 12/5/14.
//  Copyright (c) 2014 Maestro. All rights reserved.
//

import CoreData
import Foundation


extension NSManagedObjectContext {
    
    func saveRecursively(error: NSErrorPointer) -> Bool {
        var ok = false
        self.performBlockAndWait { () -> Void in
            var context: NSManagedObjectContext? = self
            do {
                var cdError: NSError? = nil
                ok = context!.save(&cdError)
                if ok {
                    context = context!.parentContext
                } else {
                    if error != nil {
                        error.memory = cdError
                    }
                }
            } while (context != nil && ok == true)
        }
        return ok
    }
    
    func fetchEntitiesNamed(name: NSString, sortDescriptors: [AnyObject]?, predicate: NSPredicate?, error: NSErrorPointer) -> [AnyObject]? {
        
        var fetchRequest = NSFetchRequest(entityName: name)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        var fetchError: NSError? = nil
        return self.executeFetchRequest(fetchRequest, error: &fetchError)
    }
    
}