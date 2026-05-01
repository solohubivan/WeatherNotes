//
//  WeatherNotesScreenView.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import SwiftUI

struct WeatherNotesScreenView: View {
    
    @State private var viewModel = WeatherNotesScreenViewModel()
    @State private var showAddNoteScreen = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                CloudySkyBackgroundView()
                notesList
            }
            .onAppear {
                viewModel.fetchNotes()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    buttonPlus
                }
            }
            .navigationDestination(isPresented: $showAddNoteScreen) {
                AddNoteScreenView()
            }
            .navigationDestination(item: $viewModel.selectedNote) { note in
                WeatherNoteDetailScreenView(note: note)
            }
        }
    }
    
    // MARK: - UI components
    private var buttonPlus: some View {
        Button {
            showAddNoteScreen = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 30, weight: .regular))
        }
        .foregroundColor(.blue)
    }
    
    private var mainTitleText: some View {
        HStack {
            Text("Weather Notes")
                .font(.system(size: 37, weight: .bold))
            
            Spacer()
        }
        .padding(16)
    }
    
    private var notesList: some View {
        List {
            mainTitleText
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            
            ForEach(viewModel.notes) { note in
                WeatherNoteCellView(note: note)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .onTapGesture {
                        viewModel.selectedNote = note
                    }
                    .swipeActions(edge: .trailing) {
                        buttonDelete(for: note)
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .background(Color.clear)
    }
    
    private func buttonDelete(for note: NoteItem) -> some View {
        Button(role: .destructive) {
            viewModel.deleteNote(note)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}

#Preview {
    NavigationStack {
        WeatherNotesScreenView()
    }
}
