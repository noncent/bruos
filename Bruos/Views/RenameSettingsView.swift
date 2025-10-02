import SwiftUI

struct RenameSettingsView: View {
    @ObservedObject var renameSettings: RenameSettings
    @ObservedObject var fileManager: FileManager
    @Binding var selectedFiles: Set<FileItem>
    @State private var expandedSections: Set<SettingSection> = [.caseStyle]
    @State private var isApplying = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Rename Settings")
                    .font(.headline)
                
                Spacer()
                
                Button("Reset") {
                    resetSettings()
                }
                .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Settings sections
            ScrollView {
                VStack(spacing: 16) {
                    // Case Style Section
                    SettingSectionView(
                        title: "Case Style",
                        isExpanded: expandedSections.contains(.caseStyle)
                    ) {
                        CaseStyleSection(renameSettings: renameSettings)
                    } onToggle: {
                        toggleSection(.caseStyle)
                    }
                    
                    // Separators Section
                    SettingSectionView(
                        title: "Separators",
                        isExpanded: expandedSections.contains(.separators)
                    ) {
                        SeparatorsSection(renameSettings: renameSettings)
                    } onToggle: {
                        toggleSection(.separators)
                    }
                    
                    // Remove/Clean Section
                    SettingSectionView(
                        title: "Remove & Clean",
                        isExpanded: expandedSections.contains(.removeClean)
                    ) {
                        RemoveCleanSection(renameSettings: renameSettings)
                    } onToggle: {
                        toggleSection(.removeClean)
                    }
                    
                    // Additions Section
                    SettingSectionView(
                        title: "Additions & Insertions",
                        isExpanded: expandedSections.contains(.additions)
                    ) {
                        AdditionsSection(renameSettings: renameSettings)
                    } onToggle: {
                        toggleSection(.additions)
                    }
                    
                    // Advanced Section
                    SettingSectionView(
                        title: "Advanced Options",
                        isExpanded: expandedSections.contains(.advanced)
                    ) {
                        AdvancedSection(renameSettings: renameSettings)
                    } onToggle: {
                        toggleSection(.advanced)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Apply button
            VStack(spacing: 12) {
                Divider()
                
                HStack {
                    Button("Undo") {
                        // TODO: Implement undo
                    }
                    .disabled(true) // Disabled until undo is implemented
                    
                    Spacer()
                    
                    Button("Apply Changes") {
                        print("DEBUG: Apply Changes button clicked")
                        applyChanges()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(selectedFiles.isEmpty || isApplying)
                }
                .padding()
            }
            .background(Color(NSColor.controlBackgroundColor))
        }
        .background(Color(NSColor.windowBackgroundColor))
        .alert("Rename Complete", isPresented: $showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Successfully renamed \(selectedFiles.count) item(s)")
        }
    }
    
    private func toggleSection(_ section: SettingSection) {
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
    }
    
    private func applyChanges() {
        print("DEBUG: applyChanges called with \(selectedFiles.count) files")
        guard !selectedFiles.isEmpty else { 
            print("DEBUG: No files selected, returning")
            return 
        }
        
        print("DEBUG: Starting rename process...")
        isApplying = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let success = self.fileManager.renameFiles(Array(self.selectedFiles), with: self.renameSettings)
            print("DEBUG: Rename result: \(success)")
            
            DispatchQueue.main.async {
                self.isApplying = false
                if success {
                    print("DEBUG: Rename successful, showing alert")
                    self.showSuccessAlert = true
                    self.selectedFiles.removeAll()
                } else {
                    print("DEBUG: Rename failed")
                }
            }
        }
    }
    
    private func resetSettings() {
        renameSettings.caseStyle = .original
        renameSettings.replaceSpacesWith = .space
        renameSettings.mergeDuplicateSeparators = false
        renameSettings.removeNumbers = false
        renameSettings.removeSpaces = false
        renameSettings.removeSpecialCharacters = false
        renameSettings.trimLeadingTrailing = false
        renameSettings.trimCount = 1
        renameSettings.prefix = ""
        renameSettings.suffix = ""
        renameSettings.autoNumbering = .none
        renameSettings.insertDate = .none
        renameSettings.dateFormat = "yyyy-MM-dd"
        renameSettings.regexFind = ""
        renameSettings.regexReplace = ""
        renameSettings.recursiveRename = false
        renameSettings.conflictResolution = .skip
    }
}

enum SettingSection: CaseIterable {
    case caseStyle, separators, removeClean, additions, advanced
}

struct SettingSectionView<Content: View>: View {
    let title: String
    let isExpanded: Bool
    let content: Content
    let onToggle: () -> Void
    
    init(title: String, isExpanded: Bool, @ViewBuilder content: () -> Content, onToggle: @escaping () -> Void) {
        self.title = title
        self.isExpanded = isExpanded
        self.content = content()
        self.onToggle = onToggle
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(NSColor.controlBackgroundColor))
                )
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(spacing: 12) {
                    content
                }
                .padding(.top, 8)
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
                )
            }
        }
    }
}

// MARK: - Section Views

struct CaseStyleSection: View {
    @ObservedObject var renameSettings: RenameSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("Case Style", selection: $renameSettings.caseStyle) {
                ForEach(CaseStyle.allCases, id: \.self) { style in
                    Text(style.rawValue).tag(style)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

struct SeparatorsSection: View {
    @ObservedObject var renameSettings: RenameSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Replace spaces with:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    ForEach(SeparatorType.allCases, id: \.self) { type in
                        Button(type.rawValue) {
                            renameSettings.replaceSpacesWith = type
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .foregroundColor(renameSettings.replaceSpacesWith == type ? .white : .primary)
                        .background(renameSettings.replaceSpacesWith == type ? Color.accentColor : Color.clear)
                    }
                }
            }
            
            Toggle("Merge duplicate separators", isOn: $renameSettings.mergeDuplicateSeparators)
                .font(.caption)
        }
    }
}

struct RemoveCleanSection: View {
    @ObservedObject var renameSettings: RenameSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle("Remove numbers", isOn: $renameSettings.removeNumbers)
            Toggle("Remove spaces", isOn: $renameSettings.removeSpaces)
            Toggle("Remove special characters", isOn: $renameSettings.removeSpecialCharacters)
            
            Toggle("Trim leading/trailing characters", isOn: $renameSettings.trimLeadingTrailing)
            
            if renameSettings.trimLeadingTrailing {
                HStack {
                    Text("Count:")
                        .font(.caption)
                    Spacer()
                    Stepper(value: $renameSettings.trimCount, in: 1...10) {
                        Text("\(renameSettings.trimCount)")
                            .font(.caption)
                    }
                    .controlSize(.small)
                }
            }
        }
        .font(.caption)
    }
}

struct AdditionsSection: View {
    @ObservedObject var renameSettings: RenameSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Prefix:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Enter prefix...", text: $renameSettings.prefix)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Suffix:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Enter suffix...", text: $renameSettings.suffix)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Auto-numbering:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Picker("Auto-numbering", selection: $renameSettings.autoNumbering) {
                    ForEach(AutoNumberingStyle.allCases, id: \.self) { style in
                        Text(style.rawValue).tag(style)
                    }
                }
                .pickerStyle(.menu)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Insert Date/Time:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Picker("Date insertion", selection: $renameSettings.insertDate) {
                    ForEach(DateInsertion.allCases, id: \.self) { insertion in
                        Text(insertion.rawValue).tag(insertion)
                    }
                }
                .pickerStyle(.menu)
                
                if renameSettings.insertDate != .none {
                    TextField("Date format (e.g., yyyy-MM-dd)", text: $renameSettings.dateFormat)
                        .textFieldStyle(.roundedBorder)
                        .font(.caption)
                }
            }
        }
    }
}

struct AdvancedSection: View {
    @ObservedObject var renameSettings: RenameSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Regex Find:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Enter regex pattern...", text: $renameSettings.regexFind)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Regex Replace:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Enter replacement...", text: $renameSettings.regexReplace)
                    .textFieldStyle(.roundedBorder)
            }
            
            Toggle("Recursive renaming (subfolders)", isOn: $renameSettings.recursiveRename)
                .font(.caption)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Conflict resolution:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Picker("Conflict resolution", selection: $renameSettings.conflictResolution) {
                    ForEach(ConflictResolution.allCases, id: \.self) { resolution in
                        Text(resolution.rawValue).tag(resolution)
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
}

#Preview {
    RenameSettingsView(
        renameSettings: RenameSettings(),
        fileManager: FileManager(),
        selectedFiles: .constant(Set<FileItem>())
    )
}
