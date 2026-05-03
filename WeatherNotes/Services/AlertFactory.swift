//
//  AlertFactory.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 01.05.2026.
//

import SwiftUI
import UIKit

struct NoInternetAlertModifier: ViewModifier {
    
    @Environment(NetworkMonitor.self) private var networkMonitor
    
    func body(content: Content) -> some View {
        content
            .alert(
                "No Internet Connection",
                isPresented: Binding(
                    get: { networkMonitor.showNoInternetAlert },
                    set: { _ in networkMonitor.dismissAlert() }
                )
            ) {
                Button("OK") {
                    networkMonitor.dismissAlert()
                }
                
                Button("Settings") {
                    networkMonitor.dismissAlert()
                    openAppSettings()
                }
            } message: {
                Text("Internet access is required for the app to work correctly.")
            }
    }
    
    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct AddNoteAlertModifier: ViewModifier {
    
    @Binding var activeAlert: AddNoteScreenViewModel.ActiveAlert?
    
    func body(content: Content) -> some View {
        content
            .alert(item: $activeAlert) { alert in
                switch alert {
                case .emptyNote:
                    return Alert(
                        title: Text("Empty Note"),
                        message: Text("Please enter note text before saving."),
                        dismissButton: .default(Text("OK"))
                    )
                    
                case .weatherUnavailable:
                    return Alert(
                        title: Text("Weather Unavailable"),
                        message: Text("Weather data is required to save a note. Please check your internet connection and try again."),
                        dismissButton: .default(Text("OK"))
                    )
                    
                case .locationAccessDenied:
                    return Alert(
                        title: Text("Location Access Required"),
                        message: Text("Location access is required to attach weather data to your note."),
                        primaryButton: .cancel(Text("Cancel")),
                        secondaryButton: .default(Text("Settings")) {
                            openAppSettings()
                        }
                    )
                }
            }
    }
    
    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

extension View {
    
    func addNoteAlert(
        activeAlert: Binding<AddNoteScreenViewModel.ActiveAlert?>
    ) -> some View {
        modifier(AddNoteAlertModifier(activeAlert: activeAlert))
    }
    
    func noInternetAlert() -> some View {
        modifier(NoInternetAlertModifier())
    }
}
