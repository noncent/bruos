import Foundation

class RenameSettings: ObservableObject {
    // Case Style
    @Published var caseStyle: CaseStyle = .original
    
    // Separators
    @Published var replaceSpacesWith: SeparatorType = .space
    @Published var mergeDuplicateSeparators = false
    
    // Remove/Clean Options
    @Published var removeNumbers = false
    @Published var removeSpaces = false
    @Published var removeSpecialCharacters = false
    @Published var trimLeadingTrailing = false
    @Published var trimCount = 1
    
    // Additions & Insertions
    @Published var prefix = ""
    @Published var suffix = ""
    @Published var autoNumbering: AutoNumberingStyle = .none
    @Published var insertDate: DateInsertion = .none
    @Published var dateFormat = "yyyy-MM-dd"
    
    // Advanced Options
    @Published var regexFind = ""
    @Published var regexReplace = ""
    @Published var recursiveRename = false
    @Published var conflictResolution: ConflictResolution = .skip
    
    // Preview & Control
    @Published var showPreview = true
}

enum CaseStyle: String, CaseIterable, Codable {
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

enum SeparatorType: String, CaseIterable, Codable {
    case space = "Space"
    case underscore = "Underscore"
    case hyphen = "Hyphen"
    case dot = "Dot"
}

enum AutoNumberingStyle: String, CaseIterable, Codable {
    case none = "None"
    case zeroPadded = "01, 001"
    case parentheses = "(1)"
    case hyphen = "-1"
}

enum DateInsertion: String, CaseIterable, Codable {
    case none = "None"
    case created = "Created Date"
    case modified = "Modified Date"
    case current = "Current Date"
}

enum ConflictResolution: String, CaseIterable, Codable {
    case skip = "Skip"
    case overwrite = "Overwrite"
    case autoRename = "Auto-rename"
}
