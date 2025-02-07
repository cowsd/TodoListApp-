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
    
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    
    func create(_ taskName: String, completion: (TodoTask) -> Void) {
        let task = TodoTask(context: viewContext)
        task.title = taskName
        completion(task)
        saveContext()
    }
    
    func fetchData(completion: (Result<[TodoTask], Error>) -> Void) {
        let fetchRequest = TodoTask.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func update(_ task: TodoTask, newTitle: String) {
        task.title = newTitle
        saveContext()
    }
    
    func delete(_ task: TodoTask) {
        viewContext.delete(task)
        saveContext()
    }
    
    
    // MARK: - Core Data Saving Support
    
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
    
    
    
}


