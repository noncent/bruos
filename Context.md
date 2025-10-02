Great — let’s map this into a **polished UI wireframe flow** so it looks like a proper **Product Design Document** your dev team can directly act on.

---

# Product Design Document

### macOS Bulk Rename App

---

## 1. High-Level UI Layout

**Window Structure (3-Pane Layout):**

* **Left Sidebar (File Explorer)**

  * Finder-style navigation tree.
  * Search bar to locate files/folders.
  * Drag & drop area for quick import.

* **Main Panel (File List & Preview)**

  * Table view with columns:

    * Checkbox (include/exclude).
    * Original Filename.
    * New Filename (live preview).
    * Path (optional).
  * Real-time updates as rules are applied.

* **Right Panel (Rename Settings)**

  * Collapsible sections with toggles, dropdowns, text fields, and sliders.
  * Designed for clarity — only show expanded section when in use.
  * Apply button anchored at bottom-right.

---

## 2. Rename Settings Panel (Right Side)

### A. **Case Style (Dropdown / Radio Group)**

* UPPERCASE
* lowercase
* Capitalize Words
* camelCase
* PascalCase
* snake\_case
* kebab-case
* dot.separated
* Snake_Case
* Kebab-Case
* Dot.Separated

---

### B. **Separators (Toggle Buttons)**

* Replace spaces with: \[Space] \[Underscore] \[Hyphen] \[Dot]
* Merge duplicate separators (checkbox).

---

### C. **Remove / Clean Options (Checkboxes)**

* Remove numbers
* Remove spaces
* Remove special characters
* Trim leading/trailing characters (with numeric input for how many).

---

### D. **Additions & Insertions**

* Prefix: \[Text field]
* Suffix: \[Text field]
* Auto-numbering: \[Dropdown → `01, 001, (1), -1`]
* Insert Date/Time: \[Dropdown → Created / Modified / Current] + Format selector.
* Metadata-based renaming: \[Dropdown → EXIF, ID3, Custom].

---

### E. **Advanced Options**

* Regex Find → \[Text field]
* Regex Replace → \[Text field]
* Recursive renaming (subfolders).
* Conflict resolution (Dropdown → Skip / Overwrite / Auto-rename).

---

### F. **Preview & Control**

* Live side-by-side preview for each selected file.
* Undo/Redo stack (toolbar).
* Apply button (highlighted in blue, bottom-right).

---

## 3. UX Enhancements

* **Animations:** Smooth expand/collapse of rename rule panels.
* **Profiles/Presets:** Save and load frequently used rename configurations.
* **Finder Extension:** Right-click → “Bulk Rename with App” shortcut.
* **Dark/Light Mode:** Automatically adapt to system preference.
* **Safety Net:** Warnings for duplicate/conflicting filenames.

---

## 4. Example Flow

1. User drags a folder into the sidebar.
2. Files populate the main panel with original names.
3. User enables:

   * Case Style → PascalCase
   * Separators → Replace spaces with underscore
   * Remove → Numbers
4. Preview updates instantly:

   * `my file 123.txt` → `My_File.txt`
5. User clicks **Apply** → All changes executed.
6. Undo available if needed.

---

## 5. Visual Style (macOS Native Aesthetics)

* Built with **SwiftUI** (clean, modern) + **AppKit** (for Finder integration).
* Rounded corners, subtle shadows, macOS vibrancy effect.
* Toolbar with minimal SF Symbols icons (Undo, Redo, Settings, Profiles).
* Smooth scrolling for long file lists.
