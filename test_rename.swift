#!/usr/bin/env swift

import Foundation

// Simple test for RenameEngine
struct FileItem {
    let name: String
    let isDirectory: Bool
    let size: Int64
    let dateModified: Date
    
    init(name: String, isDirectory: Bool = false) {
        self.name = name
        self.isDirectory = isDirectory
        self.size = 0
        self.dateModified = Date()
    }
}

struct RenameSettings {
    var caseStyle: CaseStyle = .original
    var replaceSpacesWith: SeparatorType = .space
    var mergeDuplicateSeparators = false
    var removeNumbers = false
    var removeSpaces = false
    var removeSpecialCharacters = false
    var trimLeadingTrailing = false
    var trimCount = 1
    var prefix = ""
    var suffix = ""
    var autoNumbering: AutoNumberingStyle = .none
    var insertDate: DateInsertion = .none
    var dateFormat = "yyyy-MM-dd"
    var regexFind = ""
    var regexReplace = ""
    var recursiveRename = false
    var conflictResolution: ConflictResolution = .skip
}

enum CaseStyle: String, CaseIterable {
    case original = "Original"
    case uppercase = "UPPERCASE"
    case lowercase = "lowercase"
    case capitalizeWords = "Capitalize Words"
    case camelCase = "camelCase"
    case pascalCase = "PascalCase"
    case snakeCase = "snake_case"
    case kebabCase = "kebab-case"
    case dotSeparated = "dot.separated"
    case snakeCaseCapital = "Snake_Case"
    case kebabCaseCapital = "Kebab-Case"
    case dotSeparatedCapital = "Dot.Separated"
}

enum SeparatorType: String, CaseIterable {
    case space = "Space"
    case underscore = "Underscore"
    case hyphen = "Hyphen"
    case dot = "Dot"
}

enum AutoNumberingStyle: String, CaseIterable {
    case none = "None"
    case zeroPadded = "01, 001"
    case parentheses = "(1)"
    case hyphen = "-1"
}

enum DateInsertion: String, CaseIterable {
    case none = "None"
    case created = "Created Date"
    case modified = "Modified Date"
    case current = "Current Date"
}

enum ConflictResolution: String, CaseIterable {
    case skip = "Skip"
    case overwrite = "Overwrite"
    case autoRename = "Auto-rename"
}

struct RenameEngine {
    static func generateNewName(for file: FileItem, settings: RenameSettings) -> String {
        var newName = file.name
        
        // Remove file extension temporarily
        let fileExtension = (newName as NSString).pathExtension
        let nameWithoutExtension = (newName as NSString).deletingPathExtension
        
        var processedName = nameWithoutExtension
        
        // Remove options
        if settings.removeNumbers {
            processedName = processedName.replacingOccurrences(of: "\\d+", with: "", options: .regularExpression)
        }
        
        if settings.removeSpaces {
            processedName = processedName.replacingOccurrences(of: " ", with: "")
        }
        
        if settings.removeSpecialCharacters {
            processedName = processedName.replacingOccurrences(of: "[^a-zA-Z0-9\\s]", with: "", options: .regularExpression)
        }
        
        // Trim leading/trailing characters
        if settings.trimLeadingTrailing {
            let trimCount = max(0, min(settings.trimCount, processedName.count))
            if trimCount > 0 {
                processedName = String(processedName.dropFirst(trimCount).dropLast(trimCount))
            }
        }
        
        // Replace spaces with separators
        switch settings.replaceSpacesWith {
        case .space:
            break // Keep spaces
        case .underscore:
            processedName = processedName.replacingOccurrences(of: " ", with: "_")
        case .hyphen:
            processedName = processedName.replacingOccurrences(of: " ", with: "-")
        case .dot:
            processedName = processedName.replacingOccurrences(of: " ", with: ".")
        }
        
        // Merge duplicate separators
        if settings.mergeDuplicateSeparators {
            let separator = getSeparatorString(for: settings.replaceSpacesWith)
            let pattern = "\\" + separator + "+"
            processedName = processedName.replacingOccurrences(of: pattern, with: separator, options: .regularExpression)
        }
        
        // Apply case style
        processedName = applyCaseStyle(processedName, style: settings.caseStyle)
        
        // Regex find and replace
        if !settings.regexFind.isEmpty && !settings.regexReplace.isEmpty {
            do {
                let regex = try NSRegularExpression(pattern: settings.regexFind)
                let range = NSRange(location: 0, length: processedName.utf16.count)
                processedName = regex.stringByReplacingMatches(in: processedName, options: [], range: range, withTemplate: settings.regexReplace)
            } catch {
                // Invalid regex, keep original
            }
        }
        
        // Add prefix and suffix
        if !settings.prefix.isEmpty {
            processedName = settings.prefix + processedName
        }
        
        if !settings.suffix.isEmpty {
            processedName = processedName + settings.suffix
        }
        
        // Add auto-numbering (simplified for preview)
        if settings.autoNumbering != .none {
            processedName = addAutoNumbering(processedName, style: settings.autoNumbering, index: 1)
        }
        
        // Add date
        if settings.insertDate != .none {
            processedName = addDate(processedName, insertion: settings.insertDate, format: settings.dateFormat, file: file)
        }
        
        // Re-add file extension
        if !fileExtension.isEmpty {
            newName = processedName + "." + fileExtension
        } else {
            newName = processedName
        }
        
        return newName
    }
    
    private static func getSeparatorString(for type: SeparatorType) -> String {
        switch type {
        case .space: return " "
        case .underscore: return "_"
        case .hyphen: return "-"
        case .dot: return "."
        }
    }
    
    private static func applyCaseStyle(_ text: String, style: CaseStyle) -> String {
        switch style {
        case .original:
            return text
        case .uppercase:
            return text.uppercased()
        case .lowercase:
            return text.lowercased()
        case .capitalizeWords:
            return text.capitalized
        case .camelCase:
            return toCamelCase(text)
        case .pascalCase:
            return toPascalCase(text)
        case .snakeCase:
            return toSnakeCase(text)
        case .kebabCase:
            return toKebabCase(text)
        case .dotSeparated:
            return toDotSeparated(text)
        case .snakeCaseCapital:
            return toSnakeCaseCapital(text)
        case .kebabCaseCapital:
            return toKebabCaseCapital(text)
        case .dotSeparatedCapital:
            return toDotSeparatedCapital(text)
        }
    }
    
    private static func toCamelCase(_ text: String) -> String {
        let words = text.components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
        guard !words.isEmpty else { return text }
        
        let first = words[0].lowercased()
        let rest = words.dropFirst().map { $0.capitalized }
        return first + rest.joined()
    }
    
    private static func toPascalCase(_ text: String) -> String {
        let words = text.components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
        return words.map { $0.capitalized }.joined()
    }
    
    private static func toSnakeCase(_ text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "_")
            .lowercased()
    }
    
    private static func toKebabCase(_ text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "-")
            .lowercased()
    }
    
    private static func toDotSeparated(_ text: String) -> String {
        return text.replacingOccurrences(of: " ", with: ".")
            .lowercased()
    }
    
    private static func toSnakeCaseCapital(_ text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "_")
            .capitalized
    }
    
    private static func toKebabCaseCapital(_ text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "-")
            .capitalized
    }
    
    private static func toDotSeparatedCapital(_ text: String) -> String {
        return text.replacingOccurrences(of: " ", with: ".")
            .capitalized
    }
    
    private static func addAutoNumbering(_ text: String, style: AutoNumberingStyle, index: Int) -> String {
        switch style {
        case .none:
            return text
        case .zeroPadded:
            return text + String(format: "%02d", index)
        case .parentheses:
            return text + "(\(index))"
        case .hyphen:
            return text + "-\(index)"
        }
    }
    
    private static func addDate(_ text: String, insertion: DateInsertion, format: String, file: FileItem) -> String {
        let date: Date
        
        switch insertion {
        case .none:
            return text
        case .created:
            date = file.dateModified // Using modification date as proxy for creation
        case .modified:
            date = file.dateModified
        case .current:
            date = Date()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let dateString = formatter.string(from: date)
        
        return text + "_" + dateString
    }
}

// Test the rename functionality
let testFiles = [
    FileItem(name: "test file 1.txt"),
    FileItem(name: "test file 2.pdf"),
    FileItem(name: "another file 3.jpg")
]

var settings = RenameSettings()
settings.caseStyle = .snakeCase
settings.replaceSpacesWith = .underscore

print("Testing RenameEngine:")
for file in testFiles {
    let newName = RenameEngine.generateNewName(for: file, settings: settings)
    print("\(file.name) -> \(newName)")
}
