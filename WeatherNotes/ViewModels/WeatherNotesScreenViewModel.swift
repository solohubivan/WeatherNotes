//
//  WeatherNotesScreenViewModel.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class WeatherNotesScreenViewModel {
    
    var notes: [NoteItem] = []
    var selectedNote: NoteItem?
    
    @ObservationIgnored
    private let notesStorageService: NotesStorageServiceProtocol
    
    init(notesStorageService: NotesStorageServiceProtocol? = nil) {
        self.notesStorageService = notesStorageService ?? NotesStorageService()
    }
    
    func fetchNotes() {
        notes = notesStorageService.fetchNotes()
    }
    
    func deleteNote(_ note: NoteItem) {
        notesStorageService.deleteNote(by: note.id)
        fetchNotes()
    }
}
