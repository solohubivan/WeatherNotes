//
//  CoreDataStack.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        container = NSPersistentContainer(name: "WeatherNotesDataModel")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data error: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Core Data save error:", error.localizedDescription)
        }
    }
}
