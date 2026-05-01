//
//  NoInternetAlertModifier.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 01.05.2026.
//

//import SwiftUI
//import UIKit
//
//struct NoInternetAlertModifier: ViewModifier {
//    
//    @Environment(NetworkMonitor.self) private var networkMonitor
//    
//    func body(content: Content) -> some View {
//        content
//            .alert(
//                "No Internet Connection",
//                isPresented: Binding(
//                    get: { networkMonitor.showNoInternetAlert },
//                    set: { _ in networkMonitor.dismissAlert() }
//                )
//            ) {
//                Button("OK") {
//                    networkMonitor.dismissAlert()
//                }
//                
//                Button("Settings") {
//                    networkMonitor.dismissAlert()
//                    openAppSettings()
//                }
//            } message: {
//                Text("Internet access is required for the app to work correctly.")
//            }
//    }
//    
//    private func openAppSettings() {
//        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
//        
//        if UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url)
//        }
//    }
//}
//
//extension View {
//    
//    func noInternetAlert() -> some View {
//        modifier(NoInternetAlertModifier())
//    }
//}
