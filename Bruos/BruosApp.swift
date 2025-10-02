import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // App Icon
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                .resizable()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // App Name and Version
            VStack(spacing: 8) {
                Text("Bruos")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("macOS Bulk Rename App")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("Version 1.0")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            // Creator Information
            VStack(spacing: 12) {
                Text("Made with ❤️ by")
                    .font(.headline)
                
                VStack(spacing: 8) {
                    Text("Noncent (Nono)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/noncent") {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "link")
                            Text("https://github.com/noncent")
                        }
                        .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            Divider()
            
            // FOSS Information
            VStack(spacing: 8) {
                Text("This app is completely")
                    .font(.headline)
                
                Text("FOSS (Free and Open Source Software)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                
                Text("for everyone")
                    .font(.headline)
            }
            
            Divider()
            
            // Description
            VStack(spacing: 8) {
                Text("A modern, native macOS application for bulk file renaming with an intuitive 3-pane interface.")
                    .multilineTextAlignment(.center)
                    .font(.body)
                
                Text("Built with SwiftUI for a native macOS experience.")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Close Button
            Button("Close") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
            .padding(100)
            .frame(width: 600, height: 700)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

@main
struct BruosApp: App {
    @State private var showingAbout = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .sheet(isPresented: $showingAbout) {
                    AboutView()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .help) {
                Button("About Bruos") {
                    showingAbout = true
                }
            }
        }
    }
}
