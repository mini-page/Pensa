# Settings and Backup System Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement a centralized settings page, simplify the sidebar, and build an offline-first local backup system.

**Architecture:** Refactor `AppDrawer`, create `SettingsScreen`, and implement `BackupController` using `archive` and `file_picker`.

**Tech Stack:** Flutter, Riverpod, Hive, path_provider, archive, file_picker, workmanager.

---

### Task 1: Project Setup & Dependencies

**Files:**
- Modify: `pubspec.yaml`

**Step 1: Add required dependencies**

Add `path_provider`, `archive`, `file_picker`, `permission_handler`, `workmanager`, and `share_plus` to `pubspec.yaml`.

**Step 2: Run flutter pub get**

Run: `flutter pub get`

**Step 3: Commit**

```bash
git add pubspec.yaml
git commit -m "chore: add dependencies for settings and backup system"
```

---

### Task 2: Refactor Sidebar (Simplification)

**Files:**
- Modify: `lib/features/expense/presentation/widgets/app_drawer.dart`

**Step 1: Remove granular settings tiles**

Remove `Appearance`, `Language`, `Currency`, `Privacy Mode`, and `Smart Reminders` tiles from the drawer.

**Step 2: Add Settings entry**

Add a new `ListTile` for "Settings" that navigates to a (yet to be created) `SettingsScreen`.

**Step 3: Commit**

```bash
git add lib/features/expense/presentation/widgets/app_drawer.dart
git commit -m "refactor: simplify sidebar by moving items to settings"
```

---

### Task 4: Create Settings Screen (UI)

**Files:**
- Create: `lib/features/expense/presentation/screens/settings_screen.dart`

**Step 1: Build the UI**

Implement a clean, card-based `SettingsScreen` with sections: "General" (Theme, Language, Currency), "Security" (Privacy Mode, Reminders), and "Data Management" (Backup/Restore placeholders).

**Step 2: Commit**

```bash
git add lib/features/expense/presentation/screens/settings_screen.dart
git commit -m "feat: implement centralized SettingsScreen UI"
```

---

### Task 5: Implement Backup & Restore Logic

**Files:**
- Create: `lib/features/expense/presentation/provider/backup_providers.dart`
- Create: `lib/features/expense/data/datasource/backup_local_datasource.dart`

**Step 1: Implement Export**

Write logic to find all Hive `.hive` files in the application directory, compress them into a ZIP, and save via `file_picker`.

**Step 2: Implement Import**

Write logic to read a ZIP file, extract `.hive` files, replace current storage, and restart the app/refresh providers.

**Step 3: Commit**

```bash
git add lib/features/expense/presentation/provider/backup_providers.dart lib/features/expense/data/datasource/backup_local_datasource.dart
git commit -m "feat: implement core backup and restore functionality"
```

---

### Task 6: Scheduled Backups (Background Task)

**Files:**
- Modify: `lib/main.dart`
- Modify: `lib/features/expense/presentation/provider/preferences_providers.dart` (Add backup frequency)

**Step 1: Initialize Workmanager**

Set up `workmanager` in `main.dart` to handle periodic backup tasks.

**Step 2: Implement Backup Task**

Write the background task logic to perform a silent local backup to the user-designated directory.

**Step 3: Commit**

```bash
git add lib/main.dart lib/features/expense/presentation/provider/preferences_providers.dart
git commit -m "feat: implement scheduled background backups"
```

---

### Task 7: Final Integration & Verification

**Step 1: Link Settings to Logic**

Connect the "Backup" and "Auto Backup" UI in `SettingsScreen` to the `BackupController`.

**Step 2: Run Analysis & Tests**

Run: `flutter analyze && flutter test`
Expected: PASS

**Step 3: Commit**

```bash
git add .
git commit -m "feat: complete settings and backup system integration"
```
