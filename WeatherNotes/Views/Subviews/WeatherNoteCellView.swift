//
//  WeatherNoteCellView.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 01.05.2026.
//

import SwiftUI

struct WeatherNoteCellView: View {
    
    private let viewModel: WeatherNoteCellViewModel
    
    init(note: NoteItem) {
        self.viewModel = WeatherNoteCellViewModel(note: note)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            weatherIcon
            
            VStack(alignment: .leading, spacing: 6) {
                noteTitleTxt
                noteDateCreated
            }
            
            Spacer()
            
            weatherTemp
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground).opacity(0.8))
                .shadow(color: .black.opacity(0.3), radius: 3)
        )
    }
    
    // MARK: - UI components
    
    private var noteTitleTxt: some View {
        Text(viewModel.noteText)
            .font(.system(size: 18, weight: .semibold))
            .lineLimit(1)
    }
    
    private var noteDateCreated: some View {
        Text(viewModel.formattedDate)
            .font(.system(size: 15, weight: .regular))
            .foregroundStyle(.secondary)
    }
    
    private var weatherTemp: some View {
        Text(viewModel.temperatureText)
            .font(.system(size: 24, weight: .semibold))
            .lineLimit(1)
    }
    
    private var weatherIcon: some View {
        AsyncImage(url: viewModel.weatherIconURL) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
                .progressViewStyle(.circular)
                .frame(width: 54, height: 54)
        }
        .frame(width: 54, height: 54)
    }
}

#Preview {
    WeatherNotesScreenView()
}
