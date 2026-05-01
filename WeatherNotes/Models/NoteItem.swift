//
//  NoteItem.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import Foundation

struct NoteItem: Identifiable, Hashable {
    let id: UUID
    let noteText: String
    let dateAndTime: Date
    let location: String
    let weatherDescription: String
    let weatherIcon: String
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let visibility: Int
    let latitude: Double
    let longitude: Double
}
