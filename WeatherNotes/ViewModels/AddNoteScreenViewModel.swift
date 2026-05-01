//
//  AddNoteScreenViewModel.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class AddNoteScreenViewModel {
    
    let dateAndTimeTitleText = "Date and time:"
    let locationTitleText = "Location:"
    let weatherTitleText = "Weather:"
    let notePlaceholderText = "Text note..."
    
    var noteTextValue: String = ""
    var weather: WeatherResponse?
    var errorMessage: String?
    var isLoadingWeather: Bool = false
    
    private let createdAt: Date = Date()
    
    @ObservationIgnored
    private let locationManager: LocationManager
    
    @ObservationIgnored
    private let weatherService: WeatherService
    
    @ObservationIgnored
    private let notesStorageService: NotesStorageServiceProtocol
    
    init(
        locationManager: LocationManager? = nil,
        weatherService: WeatherService? = nil,
        notesStorageService: NotesStorageServiceProtocol? = nil
    ) {
        self.locationManager = locationManager ?? LocationManager()
        self.weatherService = weatherService ?? WeatherService()
        self.notesStorageService = notesStorageService ?? NotesStorageService()
    }
    
    var dateAndTimeText: String {
        Self.dateFormatter.string(from: createdAt)
    }
    
    var locationText: String {
        guard let weather else { return "Loading..." }
        return "\(weather.name), \(weather.sys.country)"
    }
    
    var weatherText: String {
        guard let weather else { return "Loading..." }
        
        let temperature = Int(weather.main.temp.rounded())
        let description = weather.weather.first?.description.capitalized ?? "-"
        
        return "\(temperature)°, \(description)"
    }
    
    func sanitizeNoteText(_ newValue: String) {
        noteTextValue = newValue.sanitizedNote(maxLength: 200)
    }
    
    func loadWeatherForCurrentLocation() {
        isLoadingWeather = true
        
        locationManager.onLocationUpdate = { [weak self] latitude, longitude in
            Task { @MainActor in
                await self?.fetchWeather(latitude: latitude, longitude: longitude)
            }
        }
        
        locationManager.requestLocation()
    }
    
    func saveNote() {
        guard !noteTextValue.trimmed.isEmpty else { return }
        guard let weather else { return }
        
        let note = NoteItem(
            id: UUID(),
            noteText: noteTextValue.trimmed,
            dateAndTime: createdAt,
            location: "\(weather.name), \(weather.sys.country)",
            weatherDescription: weather.weather.first?.description.capitalized ?? "-",
            weatherIcon: weather.weather.first?.icon ?? "",
            temperature: weather.main.temp,
            feelsLike: weather.main.feelsLike,
            humidity: weather.main.humidity,
            pressure: weather.main.pressure,
            windSpeed: weather.wind.speed,
            visibility: weather.visibility,
            latitude: weather.coord.lat,
            longitude: weather.coord.lon
        )
        
        notesStorageService.saveNote(note)
    }
    
    private func fetchWeather(latitude: Double, longitude: Double) async {
        do {
            let result = try await weatherService.fetchWeather(
                latitude: latitude,
                longitude: longitude
            )
            
            weather = result
            errorMessage = nil
            isLoadingWeather = false
        } catch {
            errorMessage = error.localizedDescription
            isLoadingWeather = false
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
