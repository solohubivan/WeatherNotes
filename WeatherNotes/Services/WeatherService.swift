//
//  WeatherService.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import Foundation

final class WeatherService {
    
    private enum WeatherServiceError: Error {
        case invalidURL
        case invalidResponse
        case badStatusCode(Int)
        case decodingError
    }
    
    private let apiKey = "515fe6b9d0a1c97ce56f86231fdf5a97"
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw WeatherServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherServiceError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw WeatherServiceError.badStatusCode(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
