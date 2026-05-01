//
//  WeatherNoteCellViewModel.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 01.05.2026.
//

import Foundation
import Observation

@Observable
final class WeatherNoteCellViewModel {
    
    let note: NoteItem
    
    init(note: NoteItem) {
        self.note = note
    }
    
    var noteText: String {
        note.noteText
    }
    
    var temperatureText: String {
        "\(Int(note.temperature.rounded()))°C"
    }
    
    var weatherIconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(note.weatherIcon)@2x.png")
    }
    
    var formattedDate: String {
        Self.dateFormatter.string(from: note.dateAndTime)
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
