//
//  WeatherResponse.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import Foundation

struct WeatherResponse: Codable, Equatable, Hashable {
    
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let sys: Sys
    let name: String
    
    struct Weather: Codable, Equatable, Hashable {
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable, Equatable, Hashable {
        let temp: Double
        let feelsLike: Double
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
        }
    }
    
    struct Wind: Codable, Equatable, Hashable {
        let speed: Double
    }
    
    struct Sys: Codable, Equatable, Hashable {
        let country: String
    }
}
