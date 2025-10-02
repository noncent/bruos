import SwiftUI
import UniformTypeIdentifiers

struct FileExplorerView: View {
    @ObservedObject var fileManager: FileManager
    @Binding var selectedFiles: Set<FileItem>
    @State private var searchText = ""
    @State private var isDragOver = false
    @State private var showFilePicker = false
    
    var filteredFiles: [FileItem] {
        if searchText.isEmpty {
            return fileManager.files
        } else {
            return fileManager.files.filter { file in
                file.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content area
            if fileManager.currentDirectory == nil {
                // Initial state - no folder selected
                VStack(spacing: 24) {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 64))
                            .foregroundColor(.accentColor)
                        
                        Text("Select Your Folder")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Choose a folder to browse its contents, or drag files directly here")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: { openFolderPicker() }) {
                            HStack {
                                Image(systemName: "folder.badge.plus")
                                Text("Choose Folder")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        
                        Button(action: { showFilePicker = true }) {
                            HStack {
                                Image(systemName: "doc.badge.plus")
                                Text("Choose Files Instead")
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }
                    
                    Spacer()
                }
                .padding()
            } else {
                // Folder selected - show contents
                VStack(spacing: 0) {
                    // Header with current folder info
                    VStack(spacing: 8) {
                        HStack {
                            Button(action: {
                                fileManager.currentDirectory = nil
                                selectedFiles.removeAll()
                            }) {
                                Image(systemName: "arrow.left.circle")
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 2) {
                                Text(fileManager.currentDirectory?.lastPathComponent ?? "Folder")
                                    .font(.headline)
                                    .lineLimit(1)
                                
                                Text(fileManager.currentDirectory?.path ?? "")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Button(action: fileManager.loadFiles) {
                                Image(systemName: "arrow.clockwise.circle")
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        // Action buttons
                        HStack(spacing: 12) {
                            Button(action: { selectedFiles = Set(filteredFiles) }) {
                                HStack {
                                    Image(systemName: "checkmark.circle")
                                    Text("Select All")
                                }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .disabled(filteredFiles.isEmpty)
                            
                            Button(action: { selectedFiles.removeAll() }) {
                                HStack {
                                    Image(systemName: "xmark.circle")
                                    Text("Clear Selection")
                                }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .disabled(selectedFiles.isEmpty)
                            
                            Button(action: { openFolderPicker() }) {
                                HStack {
                                    Image(systemName: "folder.badge.gearshape")
                                    Text("Choose Different Folder")
                                }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass.circle")
                            .foregroundColor(.secondary)
                        
                        TextField("Search files...", text: $searchText)
                            .textFieldStyle(.plain)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(NSColor.controlBackgroundColor))
                    
                    Divider()
                    
                    // File list
                    if fileManager.isLoading {
                        Spacer()
                        ProgressView("Loading files...")
                        Spacer()
                    } else if fileManager.files.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "folder")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)
                            
                            Text("Empty Folder")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("This folder contains no files")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        Spacer()
                    } else {
                        List(filteredFiles, id: \.id) { file in
                            FileRowView(
                                file: file,
                                isSelected: selectedFiles.contains(file)
                            ) {
                                // Toggle selection for both files and folders
                                if selectedFiles.contains(file) {
                                    selectedFiles.remove(file)
                                } else {
                                    selectedFiles.insert(file)
                                }
                            }
                            .onTapGesture(count: 2) {
                                if file.isDirectory {
                                    // Double-click to navigate into folder
                                    fileManager.navigateToDirectory(file.url)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            
            // Drag and drop area (always visible at bottom)
            Rectangle()
                .fill(isDragOver ? Color.accentColor.opacity(0.3) : Color.clear)
                .frame(height: 60)
                .overlay(
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("Drop files here")
                            .font(.caption)
                    }
                    .foregroundColor(isDragOver ? .accentColor : .secondary)
                )
                .onDrop(of: [UTType.fileURL], isTargeted: $isDragOver) { providers in
                    handleFileDrop(providers: providers)
                }
        }
        .background(Color(NSColor.windowBackgroundColor))
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [.item],
            allowsMultipleSelection: true
        ) { result in
            print("DEBUG: File picker result: \(result)")
            switch result {
            case .success(let urls):
                print("DEBUG: File picker success, urls: \(urls)")
                let fileItems = urls.map { FileItem(url: $0) }
                selectedFiles = Set(fileItems)
                print("DEBUG: Selected files count: \(selectedFiles.count)")
            case .failure(let error):
                print("DEBUG: File picker error: \(error)")
            }
        }
    }
    
    private func openFolderPicker() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = false
        panel.title = "Choose Folder"
        panel.message = "Select a folder to browse its contents"
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                DispatchQueue.main.async {
                    fileManager.navigateToDirectory(url)
                    selectedFiles.removeAll()
                }
            }
        }
    }
    
    private func handleFileDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                    if let data = item as? Data,
                       let url = URL(dataRepresentation: data, relativeTo: nil) {
                        DispatchQueue.main.async {
                            fileManager.addFiles([url])
                        }
                    }
                }
            }
        }
        return true
    }
}

struct FileRowView: View {
    let file: FileItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Selection checkbox for both files and folders
            Button(action: onTap) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .font(.system(size: 16))
            }
            .buttonStyle(.plain)
            
            // File/folder icon
            Image(systemName: file.isDirectory ? "folder.fill" : "doc.fill")
                .foregroundColor(file.isDirectory ? .blue : .primary)
                .frame(width: 24)
            
            // File info
            VStack(alignment: .leading, spacing: 2) {
                Text(file.name)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                    .lineLimit(1)
                    .foregroundColor(isSelected ? .accentColor : .primary)
                
                if !file.isDirectory {
                    Text(ByteCountFormatter.string(fromByteCount: file.size, countStyle: .file))
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Double-click to open folder")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Action indicator
            if file.isDirectory {
                Image(systemName: "chevron.right.circle")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isSelected ? Color.accentColor.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .onTapGesture(count: 2) {
            if file.isDirectory {
                // Double-click to navigate into folder
                // This will be handled by the parent view
            }
        }
    }
}

#Preview {
    FileExplorerView(fileManager: FileManager(), selectedFiles: .constant(Set<FileItem>()))
}
