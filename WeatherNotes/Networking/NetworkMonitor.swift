//
//  NetworkMonitor.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 01.05.2026.
//

//import Foundation
//import Network
//import Observation
//
//enum ConnectionMode {
//    case online
//    case offline
//}
//
//protocol NetworkMonitorProtocol: AnyObject {
//    var currentConnectionMode: ConnectionMode { get }
//    var activeAlert: NetworkMonitor.ActiveAlert? { get set }
//    func clearAlert()
//}
//
//@MainActor
//@Observable
//final class NetworkMonitor: NetworkMonitorProtocol {
//    
//    enum ActiveAlert: Identifiable {
//        case noInternet
//        case internetRestored
//        
//        var id: String {
//            switch self {
//            case .noInternet: return "noInternet"
//            case .internetRestored: return "internetRestored"
//            }
//        }
//    }
//    
//    var activeAlert: ActiveAlert?
//    
//    private(set) var currentConnectionMode: ConnectionMode = .offline
//    
//    private var hasInitialStatus = false
//    private var wasOffline = false
//    
//    private let monitor = NWPathMonitor()
//    private let networkMonitoringQueue = DispatchQueue(label: "NetworkMonitoringQueue")
//    
//    // MARK: - Public Methods
//    func startMonitoring() {
//        monitor.pathUpdateHandler = { [weak self] path in
//            guard let self else { return }
//            let connected = path.status == .satisfied
//            
//            Task { @MainActor in
//                self.handleStatusChange(isConnected: connected)
//            }
//        }
//        
//        monitor.start(queue: networkMonitoringQueue)
//    }
//    
//    func stopMonitoring() {
//        monitor.cancel()
//    }
//    
//    func showNoInternetAlertIfNeeded() {
//        guard currentConnectionMode == .offline else { return }
//        activeAlert = .noInternet
//    }
//    
//    func clearAlert() {
//        activeAlert = nil
//    }
//    
//    // MARK: - Private Methods
//    private func handleStatusChange(isConnected: Bool) {
//        currentConnectionMode = isConnected ? .online : .offline
//        
//        guard hasInitialStatus else {
//            hasInitialStatus = true
//            wasOffline = !isConnected
//            
//            if !isConnected {
//                activeAlert = .noInternet
//            }
//            return
//        }
//        
//        guard isConnected else {
//            activeAlert = .noInternet
//            wasOffline = true
//            return
//        }
//        
//        guard wasOffline else { return }
//        activeAlert = .internetRestored
//        wasOffline = false
//    }
//}

//import Foundation
//import Network
//import Observation
//
//@MainActor
//@Observable
//final class NetworkMonitor {
//    
//    var showNoInternetAlert = false
//    
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "NetworkMonitoringQueue")
//    
//    func startMonitoring() {
//        monitor.pathUpdateHandler = { [weak self] path in
//            guard let self else { return }
//            
//            Task { @MainActor in
//                self.showNoInternetAlert = path.status != .satisfied
//            }
//        }
//        
//        monitor.start(queue: queue)
//    }
//    
//    func dismissAlert() {
//        showNoInternetAlert = false
//    }
//}

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
