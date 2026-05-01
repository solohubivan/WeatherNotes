//
//  WeatherResponse.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import Foundation

struct WeatherResponse: Codable, Equatable, Hashable {
    
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let visibility: Int
    let sys: Sys
    let name: String
    
    struct Coord: Codable, Equatable, Hashable {
        let lon: Double
        let lat: Double
    }
    
    struct Weather: Codable, Equatable, Hashable {
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable, Equatable, Hashable {
        let temp: Double
        let feelsLike: Double
        let pressure: Int
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case pressure
            case humidity
        }
    }
    
    struct Wind: Codable, Equatable, Hashable {
        let speed: Double
    }
    
    struct Sys: Codable, Equatable, Hashable {
        let country: String
    }
}
