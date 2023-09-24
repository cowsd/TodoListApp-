//
//  StorageManager.swift
//  TodoListApp
//
//  Created by Alex Pesenka on 05/02/25.
//

import CoreData
import Foundation

final class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteTask(task: TodoTask) {
        let context = persistentContainer.viewContext
        context.delete(task)
        saveContext()
    }
}

