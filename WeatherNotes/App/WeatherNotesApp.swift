//
//  WeatherNotesApp.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import SwiftUI

@main
struct WeatherNotesApp: App {
    
    @State private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            WeatherNotesScreenView()
                .environment(networkMonitor)
                .onAppear {
                    networkMonitor.startMonitoring()
                }
        }
    }
}
