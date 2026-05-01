//
//  AddNoteScreenView.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import SwiftUI

struct AddNoteScreenView: View {
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    @State private var viewModel = AddNoteScreenViewModel()
    @State private var showSavedView = false
    
    var body: some View {
        ZStack {
            CloudySkyBackgroundView()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    noteTextView
                    noteProperties
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
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
            ToolbarItem(placement: .topBarTrailing) {
                buttonSave
            }
        }
        .overlay {
            if showSavedView {
                savedOverlay
            }
        }
        .noInternetAlert()
        .addNoteAlert(activeAlert: $viewModel.activeAlert)
    }
    
    // MARK: - UI components
    private var buttonSave: some View {
        Button("Save") {
            saveNote()
        }
        .fontWeight(.semibold)
        .foregroundColor(.blue)
    }
    
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
        .frame(height: 180)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground).opacity(0.5))
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
                .fill(Color(.systemBackground).opacity(0.5))
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
    
    private var savedOverlay: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.green)
                
                Text("Saved!")
                    .font(.system(size: 28, weight: .bold))
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.2), radius: 10)
            )
        }
    }
    
    // MARK: - Private helpers
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
                .font(.system(size: 17, weight: .medium))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 17, weight: .medium))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
    
    private func saveNote() {
        let didSave = viewModel.saveNote()
        guard didSave else { return }
        
        isFocused = false
        showSavedView = true
        
        Task {
            try? await Task.sleep(for: .seconds(1))
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        AddNoteScreenView()
    }    
}
