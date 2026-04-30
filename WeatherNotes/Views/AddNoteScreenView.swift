//
//  AddNoteScreenView.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import SwiftUI

struct AddNoteScreenView: View {
    
    @State private var viewModel = AddNoteScreenViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color.addNoteBackground.ignoresSafeArea()
            
            VStack(spacing: 25) {
                noteTextView
                noteProperties
                Spacer()
            }
            .padding(16)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
        }
        .onAppear {
            viewModel.loadWeatherForCurrentLocation()
        }
        .navigationTitle("New note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        
                    }
                    .foregroundColor(.blue)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if !viewModel.noteTextValue.isEmpty{
                            viewModel.saveNote()
                        }
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                }
            }
    }
    
    // MARK: - UI components
    private var noteTextView: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $viewModel.noteTextValue)
                .font(.system(size: 18, weight: .semibold))
                .focused($isFocused)
                .padding(8)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .onChange(of: viewModel.noteTextValue) { _, newValue in
                    viewModel.sanitizeNoteText(newValue)
                }
            
            if viewModel.noteTextValue.isEmpty {
                Text(viewModel.notePlaceholderText)
                    .foregroundColor(.gray)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 16)
                    .padding(.leading, 14)
                    .allowsHitTesting(false)
            }
            
            if isFocused {
                doneButton
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.3), radius: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
    }
    
    private var doneButton: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    isFocused = false
                } label: {
                    Text("Done")
                        .foregroundColor(.blue)
                        .font(.system(size: 18, weight: .bold))
                }
            }
        }
        .padding(.bottom, 10)
        .padding(.trailing, 14)
    }
    
    private var noteProperties: some View {
        VStack(spacing: 0) {
            infoRow(
                icon: "calendar",
                title: viewModel.dateAndTimeTitleText,
                value: viewModel.dateAndTimeText
            )
            
            separateLine
            
            infoRow(
                icon: "location.magnifyingglass",
                title: viewModel.locationTitleText,
                value: viewModel.locationText
            )
            
            separateLine
            
            infoRow(
                icon: "cloud.sun.bolt.fill",
                title: viewModel.weatherTitleText,
                value: viewModel.weatherText
            )
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.3), radius: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
    }
    
    private var separateLine: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.4))
            .frame(height: 1.2)
            .padding(.horizontal, 16)
    }
    
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
            
            Text(title)
                .font(.system(size: 17, weight: .regular))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 17, weight: .regular))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
}

#Preview {
    NavigationStack {
        AddNoteScreenView()
    }
    
}
