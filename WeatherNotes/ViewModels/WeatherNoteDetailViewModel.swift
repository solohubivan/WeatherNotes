//
//  WeatherNoteDetailViewModel.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 01.05.2026.
//

import Foundation
import Observation

@Observable
final class WeatherNoteDetailViewModel {
    
    let note: NoteItem

    let temperatureTitle = "Temperature"
    let feelsLikeTitle = "Feels like"
    let humidityTitle = "Humidity"
    let windTitle = "Wind"
    let pressureTitle = "Pressure"
    let visibilityTitle = "Visibility"
    
    init(note: NoteItem) {
        self.note = note
    }
    
    var weatherIconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(note.weatherIcon)@2x.png")
    }
    
    var formattedDate: String {
        Self.dateFormatter.string(from: note.dateAndTime)
    }
    
    var temperatureText: String {
        "\(Int(note.temperature.rounded()))°C"
    }
    
    var feelsLikeText: String {
        "\(Int(note.feelsLike.rounded()))°C"
    }
    
    var humidityText: String {
        "\(note.humidity)%"
    }
    
    var windText: String {
        "\(note.windSpeed, default: "%.1f") m/s"
    }
    
    var pressureText: String {
        "\(note.pressure) hPa"
    }
    
    var visibilityText: String {
        "\(Double(note.visibility) / 1000, default: "%.1f") km"
    }
    
    var coordinatesText: String {
        "\(note.latitude, default: "%.4f"), \(note.longitude, default: "%.4f")"
    }
    
    var weatherDescription: String {
        note.weatherDescription.capitalized
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
