//
//  CloudySkyBackgroundView.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 01.05.2026.
//

import SwiftUI

struct CloudySkyBackgroundView: View {
    
    @State private var moveClouds = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.4),
                    Color.cyan.opacity(0.4),
                    Color.white.opacity(0.5)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            cloud(
                systemName: "cloud.fill",
                size: 120,
                opacity: 0.45,
                yOffset: -260,
                duration: 26,
                startX: -260,
                endX: 260
            )
            
            cloud(
                systemName: "cloud.fill",
                size: 170,
                opacity: 0.25,
                yOffset: -120,
                duration: 34,
                startX: 280,
                endX: -280
            )
            
            cloud(
                systemName: "cloud.fill",
                size: 100,
                opacity: 0.5,
                yOffset: 80,
                duration: 30,
                startX: -240,
                endX: 240
            )
        }
        .onAppear {
            moveClouds = true
        }
    }
    
    private func cloud(
        systemName: String,
        size: CGFloat,
        opacity: Double,
        yOffset: CGFloat,
        duration: Double,
        startX: CGFloat,
        endX: CGFloat
    ) -> some View {
        Image(systemName: systemName)
            .font(.system(size: size))
            .foregroundColor(.white)
            .opacity(opacity)
            .offset(
                x: moveClouds ? endX : startX,
                y: yOffset
            )
            .animation(
                .linear(duration: duration)
                .repeatForever(autoreverses: true),
                value: moveClouds
            )
    }
}
