//
//  CoreData.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 4/6/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObjectContext {
    func performBlockAndUpdate(context viewContext: NSManagedObjectContext = CoreDataManager.viewContext, notificationCenter: NotificationCenter, updateBlock: @escaping () -> Void) -> NSObjectProtocol {
        
        self.perform(updateBlock)
        
        let observer = notificationCenter.addObserver(forName: .NSManagedObjectContextDidSave, object: self, queue: nil) { changes in
            print("Merging changess into the view context")
            print(changes)
            viewContext.perform {
                viewContext.mergeChanges(fromContextDidSave: changes)
            }
        }
        return observer
    }
}


class CoreDataManager {
    static var container: NSPersistentContainer = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer
    }()
    static var viewContext: NSManagedObjectContext = {
//        CoreDataManager.container.viewContext.automaticallyMergesChangesFromParent = true
        return CoreDataManager.container.viewContext
    }()
    
    static func person(in persistentContainer: NSPersistentContainer) -> Person {
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        
        let persons: [Person] = try! persistentContainer.viewContext.fetch(fetchRequest) as [Person]
        
        return persons.first!
    }
    
    static func newBackgroundContext() -> NSManagedObjectContext {
        return CoreDataManager.container.newBackgroundContext()
    }
    
    static func newMainContext() -> NSManagedObjectContext {
        let newMainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        newMainContext.persistentStoreCoordinator = CoreDataManager.container.persistentStoreCoordinator
        return newMainContext
    }
}

extension Sequence where Element: NSManagedObject {
    func filter(byEntityName entityName: String) -> [Element] {
        return filter { $0.entity.name == entityName }
    }
    func filter(by managedObjectID: NSManagedObjectID) -> [Element] {
        return filter { $0.objectID == managedObjectID }
    }
}
