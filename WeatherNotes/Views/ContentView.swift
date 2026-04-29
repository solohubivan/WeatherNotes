//
//  ContentView.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            locationManager.onLocationUpdate = { latitude, longitude in
                    print("Latitude:", latitude)
                    print("Longitude:", longitude)
                }
            locationManager.requestLocation()
        }
    }
}

#Preview {
    ContentView()
}
