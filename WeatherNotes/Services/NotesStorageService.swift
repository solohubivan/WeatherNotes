//
//  NotesStorageService.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import CoreData

protocol NotesStorageServiceProtocol {
    func saveNote(_ note: NoteItem)
    func fetchNotes() -> [NoteItem]
    func fetchNote(by id: UUID) -> NoteItem?
    func deleteNote(by id: UUID)
}

final class NotesStorageService: NotesStorageServiceProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func saveNote(_ note: NoteItem) {
        let entity = NoteEntity(context: context)
        entity.id = note.id
        entity.noteText = note.noteText
        entity.dateAndTime = note.dateAndTime
        entity.location = note.location
        entity.weatherDescription = note.weatherDescription
        entity.weatherIcon = note.weatherIcon
        entity.temperature = note.temperature
        entity.feelsLike = note.feelsLike
        entity.humidity = Int64(note.humidity)
        entity.pressure = Int64(note.pressure)
        entity.windSpeed = note.windSpeed
        entity.visibility = Int64(note.visibility)
        entity.latitude = note.latitude
        entity.longitude = note.longitude
        
        do {
            try context.save()
        } catch {
            print("Failed to save note:", error.localizedDescription)
        }
    }
    
    func fetchNotes() -> [NoteItem] {
        let request = NoteEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \NoteEntity.dateAndTime, ascending: false)
        ]
        
        do {
            let entities = try context.fetch(request)
            return entities.compactMap { mapToNoteItem($0) }
        } catch {
            print("Failed to fetch notes:", error.localizedDescription)
            return []
        }
    }
    
    func fetchNote(by id: UUID) -> NoteItem? {
        let request = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first.flatMap { mapToNoteItem($0) }
        } catch {
            print("Failed to fetch note:", error.localizedDescription)
            return nil
        }
    }
    
    func deleteNote(by id: UUID) {
        let request = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                try context.save()
            }
        } catch {
            print("Failed to delete note:", error.localizedDescription)
        }
    }
    
    private func mapToNoteItem(_ entity: NoteEntity) -> NoteItem? {
        guard
            let id = entity.id,
            let noteText = entity.noteText,
            let dateAndTime = entity.dateAndTime,
            let location = entity.location,
            let weatherDescription = entity.weatherDescription,
            let weatherIcon = entity.weatherIcon
        else {
            return nil
        }
        
        return NoteItem(
            id: id,
            noteText: noteText,
            dateAndTime: dateAndTime,
            location: location,
            weatherDescription: weatherDescription,
            weatherIcon: weatherIcon,
            temperature: entity.temperature,
            feelsLike: entity.feelsLike,
            humidity: Int(entity.humidity),
            pressure: Int(entity.pressure),
            windSpeed: entity.windSpeed,
            visibility: Int(entity.visibility),
            latitude: entity.latitude,
            longitude: entity.longitude
        )
    }
}
