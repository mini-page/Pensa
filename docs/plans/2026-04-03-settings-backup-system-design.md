# Settings and Backup System Design

**Goal**: Create a centralized Settings page to simplify the sidebar and implement a robust, offline-first local backup system (Export/Import/Scheduled).

## Architecture & Components

### 1. Centralized Settings Page (`SettingsScreen`)
*   **Visual Style**: Use a clean, card-based layout with soft shadows and clear typography. Group settings into "General", "Security & Privacy", and "Data Management".
*   **Icons**: Use high-quality rounded icons in a soft blue background (`AppColors.lightBlueBg`) for each setting tile.
*   **Interactions**: Use adaptive switches for toggles and bottom sheets for selection lists (Language, Currency) to maximize user comfort.

### 2. Sidebar Simplification (`AppDrawer`)
*   **Refactor**: Remove granular settings tiles.
*   **Consolidation**: Add a single "Settings" entry that navigates to `SettingsScreen`.
*   **Focus**: Keep the drawer focused on high-level navigation and the profile header.

### 3. Data Management System (`BackupController`)
*   **Export**:
    *   Compress Hive `.hive` files and a `metadata.json` into a `.xpensa` ZIP archive.
    *   Use `file_picker` for user-selected save locations.
*   **Import**:
    *   Verify file signature/format.
    *   Provide a "Restore" flow with a confirmation dialog explaining that current data will be overwritten.
*   **Scheduled Backups**:
    *   Use a background task manager (e.g., `workmanager`) to run periodic tasks.
    *   **Permission**: Request persistent directory access.
    *   **Logic**: Generate a timestamped backup file in the designated folder based on the selected frequency (Daily, Weekly, Monthly).

## Data Flow
1.  User updates a preference in `SettingsScreen`.
2.  `AppPreferencesController` saves the change to Hive.
3.  If "Auto Backup" is enabled, the scheduled task triggers at the defined interval.
4.  The task reads all active Hive boxes and copies them to the backup location.

## Error Handling & Feedback
*   Show distinct "Success" and "Error" snackbars with descriptive messages.
*   Validate file integrity before starting an import.
*   Handle "Storage Permission Denied" gracefully with instructions.

## UI/UX Polish
*   Use smooth hero transitions or slide animations when entering Settings.
*   Ensure all text uses `AppTextStyles` for consistent hierarchy.
*   Provide a "Last Backup" timestamp display in the Data Management section.
