//
//  LocationManager.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

//import Foundation
//import CoreLocation
//
//@Observable
//final class LocationManager: NSObject {
//    
//    var locationAccessDenied: Bool = false
//    var onLocationUpdate: ((Double, Double) -> Void)?
//    private let locationManager = CLLocationManager()
//    
//    override init() {
//        super.init()
//        setupLocationManager()
//        requestLocation()
//    }
//    
//    // MARK: - Methods for External Use
//    func requestLocation() {
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//    }
//    
//    // MARK: - Configuration
//    private func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.startUpdatingLocation()
//    }
//}
//
//// MARK: - CLLocationManagerDelegate
//extension LocationManager: CLLocationManagerDelegate {
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedAlways, .authorizedWhenInUse:
//            locationAccessDenied = false
//            locationManager.requestLocation()
//        case .denied, .restricted:
//            locationAccessDenied = true
//        default:
//            break
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            onLocationUpdate?(location.coordinate.latitude, location.coordinate.longitude)
//            locationManager.stopUpdatingLocation()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        // Intentionally left empty
//    }
//}

import Foundation
import CoreLocation

@Observable
final class LocationManager: NSObject {
    
    var locationAccessDenied: Bool = false
    var onLocationUpdate: ((Double, Double) -> Void)?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Methods for External Use
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // MARK: - Configuration
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationAccessDenied = false
            locationManager.requestLocation()
        case .denied, .restricted:
            locationAccessDenied = true
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        onLocationUpdate?(
            location.coordinate.latitude,
            location.coordinate.longitude
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error.localizedDescription)
    }
}
