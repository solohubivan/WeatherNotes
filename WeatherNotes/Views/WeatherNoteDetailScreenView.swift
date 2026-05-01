//
//  WeatherNoteDetailScreenView.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 01.05.2026.
//

import SwiftUI

struct WeatherNoteDetailScreenView: View {
    
    @Environment(\.dismiss) private var dismiss
    private let viewModel: WeatherNoteDetailViewModel
    
    init(note: NoteItem) {
        self.viewModel = WeatherNoteDetailViewModel(note: note)
    }
    
    var body: some View {
        ZStack {
            CloudySkyBackgroundView()
            
            ScrollView(.vertical, showsIndicators: false) {
                noteText
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                dateAndTime
                weatherMainInfo
                    .padding(.bottom, 20)
                weatherDetailInfo
                    .padding(.bottom, 10)
                locationInfo
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - UI components
    private var noteText: some View {
        HStack {
            Text(viewModel.note.noteText)
                .font(.system(size: 28, weight: .semibold))
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
    
    private var dateAndTime: some View {
        HStack {
            Text(viewModel.formattedDate)
                .font(.system(size: 18, weight: .regular))
                .multilineTextAlignment(.leading)
                .foregroundColor(.black.opacity(0.7))
            
            Spacer()
        }
    }
    
    private var weatherMainInfo: some View {
        HStack {
            AsyncImage(url: viewModel.weatherIconURL) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
            .frame(height: 100)
            
            VStack(alignment: .leading) {
                Text(viewModel.temperatureText)
                    .font(.system(size: 40, weight: .semibold))
                
                Text(viewModel.weatherDescription)
                    .font(.system(size: 16, weight: .regular))
            }
            
            Spacer()
        }
    }
    
    private var weatherDetailInfo: some View {
        VStack(spacing: 0) {
            infoRow(
                icon: "thermometer.medium",
                title: viewModel.temperatureTitle,
                value: viewModel.temperatureText
            )
            
            separateLine
            
            infoRow(
                icon: "thermometer.sun",
                title: viewModel.feelsLikeTitle,
                value: viewModel.feelsLikeText
            )
            
            separateLine
            
            infoRow(
                icon: "humidity",
                title: viewModel.humidityTitle,
                value: viewModel.humidityText
            )
            
            separateLine
            
            infoRow(
                icon: "wind",
                title: viewModel.windTitle,
                value: viewModel.windText
            )
            
            separateLine
            
            infoRow(
                icon: "gauge.with.dots.needle.bottom.50percent",
                title: viewModel.pressureTitle,
                value: viewModel.pressureText
            )
            
            separateLine
            
            infoRow(
                icon: "eye",
                title: viewModel.visibilityTitle,
                value: viewModel.visibilityText
            )
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground).opacity(0.5))
                .shadow(color: .black.opacity(0.2), radius: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
        .padding(.horizontal, 2)
    }
    
    private var locationInfo: some View {
        VStack(spacing: 10) {
            HStack(spacing: 16) {
                Image(systemName: "map")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                
                Text(viewModel.note.location)
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                Image(systemName: "location")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                
                Text(viewModel.coordinatesText)
                    .font(.system(size: 16, weight: .regular))
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground).opacity(0.5))
                .shadow(color: .black.opacity(0.2), radius: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
        .padding(.horizontal, 1)
    }
    
    private var separateLine: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.4))
            .frame(height: 1.2)
            .padding(.horizontal, 16)
    }
    
    // MARK: - Private helper
    private func infoRow(
        icon: String,
        title: String,
        value: String,
        iconColor: Color = .blue
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 23, height: 23)
            
            Text(title)
                .font(.system(size: 16, weight: .regular))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 17, weight: .medium))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
    }
}

#Preview {
    NavigationStack {
        WeatherNoteDetailScreenView(
            note: NoteItem(
                id: UUID(),
                noteText: "Morning run in the park",
                dateAndTime: Date(),
                location: "Kyiv, UA",
                weatherDescription: "Partly cloudy",
                weatherIcon: "02d",
                temperature: 18.4,
                feelsLike: 17.8,
                humidity: 65,
                pressure: 1012,
                windSpeed: 3.6,
                visibility: 10000,
                latitude: 50.4501,
                longitude: 30.5234
            )
        )
    }
}
