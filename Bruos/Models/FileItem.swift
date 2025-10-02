import Foundation

struct FileItem: Identifiable, Hashable, Codable {
    let id: UUID
    let url: URL
    let name: String
    let isDirectory: Bool
    let size: Int64
    let dateModified: Date
    
    var displayName: String {
        name
    }
    
    var path: String {
        url.path
    }
    
    init(url: URL) {
        self.id = UUID()
        self.url = url
        self.name = url.lastPathComponent
        self.isDirectory = url.hasDirectoryPath
        
        let attributes = try? Foundation.FileManager.default.attributesOfItem(atPath: url.path)
        self.size = attributes?[.size] as? Int64 ?? 0
        self.dateModified = attributes?[.modificationDate] as? Date ?? Date()
    }
}

extension FileItem {
    static let sampleFiles = [
        FileItem(url: URL(fileURLWithPath: "/Users/sample/Documents/my file 123.txt")),
        FileItem(url: URL(fileURLWithPath: "/Users/sample/Documents/another file 456.pdf")),
        FileItem(url: URL(fileURLWithPath: "/Users/sample/Documents/photo 001.jpg")),
        FileItem(url: URL(fileURLWithPath: "/Users/sample/Documents/vacation photos 2023.png"))
    ]
}
