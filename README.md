# Bruos - macOS Bulk Rename App

[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)](https://www.apple.com/macos/)
[![Xcode](https://img.shields.io/badge/Xcode-15.0+-blue.svg)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![FOSS](https://img.shields.io/badge/FOSS-Yes-brightgreen.svg)](https://github.com/noncent/bruos)

A modern, native macOS application for bulk file renaming with an intuitive 3-pane interface. Built with SwiftUI for a native macOS experience.

![Bruos App Icon](public/icons/512.png)

## 📸 Screenshots

*Screenshots coming soon - showing the 3-pane interface, rename settings, and About dialog*

## ✨ Recent Updates

- **Custom App Icons**: Beautiful PNG icons integrated for all macOS icon sizes
- **Help Menu**: Custom Help menu with "About Bruos" option
- **About Dialog**: Professional About popup with creator information and FOSS declaration
- **Enhanced UI**: Improved padding and spacing for better visual hierarchy

## Features

### 🎯 Core Functionality
- **3-Pane Layout**: File explorer, file list with preview, and rename settings
- **Real-time Preview**: See changes before applying them
- **Drag & Drop**: Easy file import from Finder
- **Multiple Rename Options**: Case styles, separators, additions, and advanced regex

### 📁 File Management
- **Finder-style Navigation**: Browse directories with familiar interface
- **File Selection**: Checkbox-based file selection
- **Search**: Quick file search within current directory
- **File Information**: Display file size, modification date, and path

### 🔧 Rename Options

#### Case Styles
- UPPERCASE, lowercase, Capitalize Words
- camelCase, PascalCase
- snake_case, kebab-case, dot.separated
- Snake_Case, Kebab-Case, Dot.Separated

#### Separators
- Replace spaces with: Space, Underscore, Hyphen, Dot
- Merge duplicate separators option

#### Remove & Clean
- Remove numbers, spaces, special characters
- Trim leading/trailing characters (configurable count)

#### Additions & Insertions
- Prefix and suffix text
- Auto-numbering: 01, 001, (1), -1
- Date/Time insertion: Created, Modified, Current
- Custom date format support

#### Advanced Options
- Regex find and replace
- Recursive renaming (subfolders)
- Conflict resolution: Skip, Overwrite, Auto-rename

### 🎨 User Experience
- **Native macOS Design**: Built with SwiftUI for modern, native feel
- **Custom App Icons**: Professional PNG icons for all macOS icon sizes
- **Help Menu Integration**: Custom Help menu with About dialog
- **Dark/Light Mode**: Automatic system preference adaptation
- **Smooth Animations**: Expandable settings sections
- **Professional About Dialog**: Creator information and FOSS declaration
- **Undo/Redo**: Full undo/redo support (planned)
- **Profiles/Presets**: Save and load rename configurations (planned)

## Technical Details

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **ObservableObject**: Reactive data binding
- **File System Integration**: Native file operations

### File Structure
```
Bruos/
├── BruosApp.swift              # Main app entry point with About dialog
├── ContentView.swift           # Main 3-pane layout
├── Models/
│   ├── FileItem.swift          # File representation model
│   └── RenameSettings.swift    # Rename configuration model
├── ViewModels/
│   └── FileManager.swift       # File system operations
├── Views/
│   ├── FileExplorerView.swift  # Left sidebar file browser
│   ├── FileListView.swift      # Main file list with preview
│   └── RenameSettingsView.swift # Right panel settings
├── Utils/
│   └── RenameEngine.swift      # Core rename logic
├── Assets.xcassets/
│   └── AppIcon.appiconset/     # Custom PNG app icons
└── public/
    └── icons/                  # Source PNG icon files
```

### Requirements
- **macOS**: 13.0 or later
- **Xcode**: 15.0 or later
- **Swift**: 5.0 or later

## Installation

### From Source
1. Clone the repository:
   ```bash
   git clone https://github.com/noncent/bruos.git
   cd bruos
   ```
2. Open `Bruos.xcodeproj` in Xcode
3. Build and run the project (⌘+R)

### Build Requirements
- **Xcode**: 15.0 or later
- **macOS**: 13.0 or later (for development)
- **Swift**: 5.0 or later

### Quick Start
1. Launch the app
2. Navigate to your desired folder using the left sidebar
3. Select files you want to rename
4. Configure rename settings in the right panel
5. Preview changes in the main panel
6. Click "Apply Changes" to rename files

## Usage

### Basic Workflow
1. **Open the app** - Starts in Documents directory
2. **Navigate** - Use the left sidebar to browse folders
3. **Select files** - Check files you want to rename
4. **Configure settings** - Use the right panel to set rename rules
5. **Preview changes** - See real-time preview in the main panel
6. **Apply changes** - Click "Apply Changes" to rename files

### Advanced Features
- **Drag & Drop**: Drag files from Finder into the app
- **Search**: Use the search bar to quickly find files
- **Regex**: Use advanced regex patterns for complex renaming
- **Help Menu**: Access "About Bruos" from the Help menu
- **About Dialog**: View app information, creator details, and FOSS declaration
- **Profiles**: Save and reuse rename configurations (coming soon)

## Development

### Project Setup
The project uses a standard Xcode project structure with:
- SwiftUI for UI
- Combine for reactive programming
- FileManager for file operations
- Regular expressions for advanced renaming

### Key Components

#### FileItem
Represents a file with metadata:
- URL, name, directory flag
- Size, modification date
- Display properties

#### RenameSettings
ObservableObject containing all rename configuration:
- Case styles, separators, remove options
- Prefix/suffix, auto-numbering, date insertion
- Advanced regex and conflict resolution

#### RenameEngine
Core logic for generating new filenames:
- Applies all rename rules in sequence
- Handles edge cases and validation
- Supports complex transformations

### Future Enhancements
- [ ] Undo/Redo functionality
- [ ] Profiles/Presets system
- [ ] Finder extension for right-click integration
- [ ] Batch operations
- [ ] File filtering
- [ ] Custom rename rules
- [ ] Export/Import configurations
- [ ] Additional app icon themes
- [ ] Keyboard shortcuts for common operations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## About the Creator

**Made with ❤️ by [Noncent (Nono)](https://github.com/noncent)**

This app is completely **FOSS (Free and Open Source Software)** for everyone.

## Acknowledgments

- Built with SwiftUI and native macOS frameworks
- Inspired by modern file management applications
- Designed following Apple's Human Interface Guidelines
- Custom icons and UI enhancements for professional appearance
