//
//  NetworkMonitor.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 01.05.2026.
//

import Foundation
import Network
import Observation

@MainActor
@Observable
final class NetworkMonitor {
    
    var showNoInternetAlert = false
    var imageReloadToken = UUID()
    
    private var wasOffline = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitoringQueue")
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            
            Task { @MainActor in
                let isConnected = path.status == .satisfied
                
                if isConnected {
                    if self.wasOffline {
                        self.imageReloadToken = UUID()
                    }
                    
                    self.wasOffline = false
                } else {
                    self.wasOffline = true
                    self.showNoInternetAlert = true
                }
            }
        }
        
        monitor.start(queue: queue)
    }
    
    func dismissAlert() {
        showNoInternetAlert = false
    }
}
