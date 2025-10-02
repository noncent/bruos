#!/usr/bin/env swift

import SwiftUI
import AppKit

struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            TestView()
        }
    }
}

struct TestView: View {
    @State private var message = "App is running!"
    @State private var showFilePicker = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.title)
            
            Button("Test Button") {
                print("DEBUG: Test button clicked!")
                message = "Button clicked at \(Date())"
            }
            .buttonStyle(.borderedProminent)
            
            Button("Test File Picker") {
                print("DEBUG: File picker button clicked!")
                showFilePicker = true
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [.item],
            allowsMultipleSelection: true
        ) { result in
            print("DEBUG: File picker result: \(result)")
            switch result {
            case .success(let urls):
                print("DEBUG: Selected files: \(urls)")
                message = "Selected \(urls.count) files"
            case .failure(let error):
                print("DEBUG: File picker error: \(error)")
                message = "Error: \(error.localizedDescription)"
            }
        }
    }
}

TestApp.main()
