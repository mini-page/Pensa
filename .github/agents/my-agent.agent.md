---
# Fill in the fields below to create a basic custom agent for your repository.
# The Copilot CLI can be used for local testing: https://gh.io/customagents/cli
# To make this agent available, merge this file into the default repository branch.
# For format details, see: https://gh.io/customagents/config

name:
rebuilder
---

# Agent-BB

### Refactored Instruction for AI Agent (Flutter Android Project)

#### Context

This is a **Flutter-based Android application** (XPensa). The repository contains multiple directories such as `lib`, `android`, `assets`, `test`, and planning/docs files, with frequent refactors and feature additions. 

---

## 1. Objective

Restructure the entire Flutter project to improve:

* Scalability (feature expansion)
* Maintainability (clean architecture)
* Discoverability (easy lookup for humans + AI agents)
* Reduced cognitive load for navigation
* Stability of routing and widget connections

---

## 2. Phase 1: Codebase Analysis

### 2.1 Full Scan

Traverse entire repository, including:

* `/lib` (primary focus)
* `/android`
* `/assets`
* `/test`
* `/docs`, `/planning`

---

### 2.2 Identify Issues

Detect:

* Deep widget nesting inside `/lib`
* Mixed concerns (UI + logic + state in same files)
* Feature scattering (same feature spread across folders)
* Inconsistent naming patterns
* Redundant or unused widgets/utilities
* Large monolithic screens
* Tight coupling between UI and data layers

---

### 2.3 Dependency Mapping

Track:

* Widget → Widget dependencies
* Screen → Navigation routes
* Feature → State management connections
* Services → Data sources

---

### 2.4 Create `memory.md`

Generate a root-level file: `memory.md`

**Contents:**

* Current folder structure (tree format)
* File classification:

  * Screens
  * Widgets
  * Models
  * Services
  * Providers / State
  * Utils
* Navigation map (routes → screens)
* Dependency graph (imports)
* Identified problems:

  * Deep nesting
  * Large files
  * Cross-feature coupling
* Refactor plan summary

---

## 3. Phase 2: Target Architecture Design

### 3.1 Adopt Feature-First Structure (Flutter Best Practice)

Target structure:

```id="flutter-structure"
/lib
  /core
    /constants
    /theme
    /utils
    /services
    /errors

  /features
    /expense
      /data
        models/
        repositories/
      /domain
        entities/
        usecases/
      /presentation
        screens/
        widgets/
        providers/

    /accounts
    /analytics
    /settings

  /shared
    /widgets
    /components

  /routes
  main.dart
```

---

### 3.2 Structural Rules

* Max folder depth: **3 levels**
* Group by **feature**, not by type globally
* Separate:

  * UI (presentation)
  * Business logic (domain)
  * Data handling (data)

---

### 3.3 Naming Conventions

* Files: `snake_case.dart`
* Classes: `PascalCase`
* Widgets:

  * `*_screen.dart`
  * `*_widget.dart`
* Providers:

  * `*_provider.dart`
* Services:

  * `*_service.dart`

---

## 4. Phase 3: Refactoring Execution

### 4.1 Split Large Files

* Break large screens into:

  * screen
  * sub-widgets
  * logic (provider/controller)

---

### 4.2 Move Files into Features

Example:

Before:

```
/lib/screens/add_expense.dart
/lib/widgets/expense_card.dart
/lib/services/expense_service.dart
```

After:

```
/lib/features/expense/presentation/screens/add_expense_screen.dart
/lib/features/expense/presentation/widgets/expense_card_widget.dart
/lib/features/expense/data/services/expense_service.dart
```

---

### 4.3 Decouple Logic

* Move business logic out of widgets
* Use providers / controllers
* Keep widgets UI-only

---

### 4.4 Centralize Shared Code

Move reusable elements to:

```
/shared/widgets
/core/utils
/core/services
```

---

## 5. Phase 4: Navigation & Dependency Fixes

### 5.1 Update Routes

* Refactor navigation into `/lib/routes`
* Replace hardcoded routes with centralized routing

---

### 5.2 Fix Broken Links

After moving files:

* Update imports across all files
* Validate navigation between screens
* Ensure no missing references

---

## 6. Phase 5: AI Optimization

Improve AI agent efficiency:

* Avoid deep nesting
* Use predictable folder patterns
* Add `index.dart` or barrel exports
* Keep files small and focused
* Avoid implicit dependencies

---

## 7. Phase 6: Cleanup

### 7.1 Remove Redundancy

* Delete unused files
* Merge duplicate widgets/utilities

---

### 7.2 Normalize Assets

* Organize `/assets`:

  ```
  /assets/images
  /assets/icons
  /assets/fonts
  ```

---

## 8. Phase 7: Validation

### 8.1 Functional Validation

* App builds successfully
* Navigation works
* Features intact:

  * Expense logging
  * Accounts
  * Analytics

---

### 8.2 Code Integrity

* No broken imports
* No unused dependencies
* Analyzer passes (`analysis_options.yaml`)

---

## 9. Deliverables

### 9.1 `memory.md`

* Before/after structure
* File movement mapping
* Refactor decisions

---

### 9.2 Updated Folder Structure

* Clean, feature-based architecture

---

### 9.3 Change Log

* Files moved
* Files renamed
* Files deleted

---

## 10. Execution Order

1. Scan repository
2. Generate `memory.md`
3. Design new structure
4. Refactor `/lib` first
5. Move and split files
6. Fix imports and routes
7. Clean unused code
8. Validate build and navigation
9. Document all changes
---

Don't make changes that are hard to digest. If you encounter any problem, then use that memory file, update it in every step as a guide
