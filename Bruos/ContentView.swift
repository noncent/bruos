import SwiftUI

struct ContentView: View {
    @StateObject private var fileManager = FileManager()
    @StateObject private var renameSettings = RenameSettings()
    @State private var selectedFiles: Set<FileItem> = []
    
    var body: some View {
        NavigationSplitView {
            // Left Sidebar - File Explorer
            FileExplorerView(fileManager: fileManager, selectedFiles: $selectedFiles)
                .navigationSplitViewColumnWidth(min: 250, ideal: 300, max: 400)
        } content: {
            // Main Panel - File List & Preview
            FileListView(
                fileManager: fileManager,
                renameSettings: renameSettings,
                selectedFiles: $selectedFiles
            )
        } detail: {
            // Right Panel - Rename Settings
            RenameSettingsView(
                renameSettings: renameSettings,
                fileManager: fileManager,
                selectedFiles: $selectedFiles
            )
                .navigationSplitViewColumnWidth(min: 300, ideal: 350, max: 450)
        }
        .frame(minWidth: 1000, minHeight: 600)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

#Preview {
    ContentView()
}
