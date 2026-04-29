//
//  ContentView.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var locationManager = LocationManager()
    private let weatherService = WeatherService()
    
    @State private var weather: WeatherResponse?
    @State private var errorText: String?
    
    var body: some View {
        VStack(spacing: 16) {
            
            if let weather {
                
                if let icon = weather.weather.first?.icon {
                    let iconURL = "https://openweathermap.org/img/wn/\(icon)@2x.png"
                    
                    AsyncImage(url: URL(string: iconURL)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text(weather.name)
                    .font(.title)
                
                Text("\(weather.main.temp, specifier: "%.1f")°C")
                    .font(.largeTitle)
                
                Text(weather.weather.first?.description.capitalized ?? "-")
                    .foregroundStyle(.secondary)
                
                Text("Wind: \(weather.wind.speed, specifier: "%.1f") m/s")
                    .font(.footnote)
                
            } else if let errorText {
                Text("Error: \(errorText)")
                    .foregroundColor(.red)
            } else {
                ProgressView("Loading weather...")
            }
        }
        .padding()
        .onAppear {
            setupLocation()
        }
    }
    
    private func setupLocation() {
        locationManager.onLocationUpdate = { latitude, longitude in
            
            Task {
                do {
                    let result = try await weatherService.fetchWeather(
                        latitude: latitude,
                        longitude: longitude
                    )
                    
                    await MainActor.run {
                        self.weather = result
                    }
                    
                } catch {
                    await MainActor.run {
                        self.errorText = error.localizedDescription
                    }
                }
            }
        }
        
        locationManager.requestLocation()
    }
}

#Preview {
    ContentView()
}
