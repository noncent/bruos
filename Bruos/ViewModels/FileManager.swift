import Foundation
import SwiftUI

class FileManager: ObservableObject {
    @Published var currentDirectory: URL?
    @Published var files: [FileItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let fileManager = Foundation.FileManager.default
    
    init() {
        // Start with no directory selected - show "Choose Folder" screen
        currentDirectory = nil
    }
    
    func loadFiles() {
        guard let directory = currentDirectory else { return }
        
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let contents = try self.fileManager.contentsOfDirectory(
                    at: directory,
                    includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey, .contentModificationDateKey],
                    options: [.skipsHiddenFiles]
                )
                
                let fileItems = contents.map { FileItem(url: $0) }
                    .sorted { first, second in
                        // Directories first, then files, both alphabetically
                        if first.isDirectory && !second.isDirectory {
                            return true
                        } else if !first.isDirectory && second.isDirectory {
                            return false
                        } else {
                            return first.name.localizedCaseInsensitiveCompare(second.name) == .orderedAscending
                        }
                    }
                
                DispatchQueue.main.async {
                    self.files = fileItems
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load files: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    func navigateToDirectory(_ url: URL) {
        currentDirectory = url
        loadFiles()
    }
    
    func navigateUp() {
        guard let current = currentDirectory else { return }
        let parent = current.deletingLastPathComponent()
        if parent != current {
            navigateToDirectory(parent)
        }
    }
    
    func addFiles(_ urls: [URL]) {
        // Add files to current directory for processing
        // This would typically copy or move files, but for this demo we'll just add them to the list
        let newFiles = urls.map { FileItem(url: $0) }
        files.append(contentsOf: newFiles)
    }
    
    func renameFiles(_ filesToRename: [FileItem], with settings: RenameSettings) -> Bool {
        var success = true
        var errorMessages: [String] = []
        
        for file in filesToRename {
            let newName = RenameEngine.generateNewName(for: file, settings: settings)
            
            // Skip if no change needed
            if newName == file.name {
                continue
            }
            
            let newURL = file.url.deletingLastPathComponent().appendingPathComponent(newName)
            
            do {
                try fileManager.moveItem(at: file.url, to: newURL)
            } catch {
                success = false
                errorMessages.append("Failed to rename '\(file.name)': \(error.localizedDescription)")
            }
        }
        
        if !errorMessages.isEmpty {
            DispatchQueue.main.async {
                self.errorMessage = errorMessages.joined(separator: "\n")
            }
        }
        
        // Reload files to reflect changes
        if success {
            loadFiles()
        }
        
        return success
    }
}
