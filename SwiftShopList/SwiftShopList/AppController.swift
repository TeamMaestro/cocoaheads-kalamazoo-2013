//
//  AppController.swift
//  SwiftShopList
//
//  Created by Norm Barnard on 12/4/14.
//  Copyright (c) 2014 Maestro. All rights reserved.
//

import UIKit
import CoreData

class AppController {
   
    let kStoreName = "shoppinglist.sqlite"
    let kModelName = "SwiftShopList"
    
    class var appController : AppController {
        struct Singleton {
            static let instance = AppController()
        }
        return Singleton.instance
    }

    // MARK: --= Core Data Properties =--
    
    lazy var managedObjectModel: NSManagedObjectModel? = {
        if let modelURL = NSBundle.mainBundle().URLForResource(self.kModelName, withExtension: "momd") {
            return NSManagedObjectModel(contentsOfURL: modelURL)!
        } else {
            return nil
        }
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        var psc: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel:self.managedObjectModel!)
        var storeURL = self.urlForResourceInApplicationSupport(resourceName: self.kStoreName)
        
        if self.hasEnvironmentVar("NUKE_DATABASE") {
            NSFileManager.defaultManager().removeItemAtURL(storeURL, error: nil)
        }
        
        var error : NSError? = nil
        
        var options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        psc!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options, error: &error)
        assert(error == nil, "Unable to create persistent store")
        return psc
    }()

    lazy var writeContext: NSManagedObjectContext? = {
        
        let coord = self.persistentStoreCoordinator
        if coord == nil {
            return nil
        }
        var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.persistentStoreCoordinator = coord
        context.undoManager = nil
        return context
    }()
    
    lazy var mainContext: NSManagedObjectContext? = {
        
        let coord = self.persistentStoreCoordinator
        if coord == nil {
            return nil
        }
        let parentContext = self.writeContext
        if parentContext == nil {
            return nil
        }
        
        var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.undoManager = nil
        context.parentContext = parentContext
        return context
    }()
    
    
    lazy var applicationSupportFolderURL: NSURL = {
        return NSFileManager.defaultManager().applicationSupportDirectory()
    }()
    
    // MARK: --= Methods =--
    
    func setupAppearanceProxies() -> () {
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.19, green: 0.60, blue: 1.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UIBarButtonItem.appearance().setTitleTextAttributes([ NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal);
        
    }
    
    
    func urlForResourceInApplicationSupport(#resourceName: String) -> NSURL {
        return self.applicationSupportFolderURL.URLByAppendingPathComponent(resourceName)
    }
    
    func hasEnvironmentVar(envVar : String) -> Bool {
        
        var ev = NSProcessInfo.processInfo().environment[envVar] as String?
        return (ev != nil)
        
    }
    
    
    
}
