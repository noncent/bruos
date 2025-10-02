import SwiftUI

struct FileListView: View {
    @ObservedObject var fileManager: FileManager
    @ObservedObject var renameSettings: RenameSettings
    @Binding var selectedFiles: Set<FileItem>
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack {
                Text("Items to Rename")
                    .font(.headline)
                
                Spacer()
                
                Button("Select All") {
                    selectedFiles = Set(fileManager.files)
                }
                .disabled(fileManager.files.isEmpty)
                
                Button("Clear Selection") {
                    selectedFiles.removeAll()
                }
                .disabled(selectedFiles.isEmpty)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // File list with preview
            if selectedFiles.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Text("No items selected")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Select files and folders from the sidebar to see rename preview")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                Spacer()
            } else {
                List(Array(selectedFiles).sorted { $0.name < $1.name }, id: \.id) { file in
                    FilePreviewRow(
                        file: file,
                        renameSettings: renameSettings,
                        isSelected: selectedFiles.contains(file)
                    ) {
                        if selectedFiles.contains(file) {
                            selectedFiles.remove(file)
                        } else {
                            selectedFiles.insert(file)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct FilePreviewRow: View {
    let file: FileItem
    @ObservedObject var renameSettings: RenameSettings
    let isSelected: Bool
    let onToggle: () -> Void
    
    private var newName: String {
        RenameEngine.generateNewName(for: file, settings: renameSettings)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            Button(action: onToggle) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .font(.title2)
            }
            .buttonStyle(.plain)
            
            // File icon
            Image(systemName: file.isDirectory ? "folder.fill" : "doc")
                .foregroundColor(file.isDirectory ? .blue : .primary)
                .frame(width: 24)
            
            // Original name
            VStack(alignment: .leading, spacing: 2) {
                Text(file.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(file.path)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Arrow
            Image(systemName: "arrow.right")
                .foregroundColor(.secondary)
                .font(.caption)
            
            // New name preview
            VStack(alignment: .leading, spacing: 2) {
                Text(newName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
                
                if newName != file.name {
                    Text("Preview")
                        .font(.caption)
                        .foregroundColor(.accentColor)
                } else {
                    Text("No changes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
        )
    }
}

#Preview {
    FileListView(
        fileManager: FileManager(),
        renameSettings: RenameSettings(),
        selectedFiles: .constant(Set(FileItem.sampleFiles))
    )
}
