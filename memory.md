# XPensa – Project Memory

> **Purpose:** Living reference for AI agents and developers. Update this file at every structural change. Last updated: 2026-04-04.

---

## 1. Repository Layout (as of 2026-04-04)

```
XPensa/
├── android/                          # Android platform project
│   └── app/src/main/
│       ├── kotlin/app/xpensa/finance/MainActivity.kt
│       └── res/                      # Launcher icons, splash assets
├── assets/
│   └── icon/                         # app_icon.png, xpensa_logo.png, splash_mark.png
├── benchmark/                        # Standalone Dart performance benchmarks
├── docs/
│   ├── ai/                           # Agent guides: AGENTS.md, CLAUDE.md, NEW_SESSION_PLAN.md
│   └── plans/                        # Feature design docs (markdown)
├── lib/
│   ├── core/
│   │   ├── constants/app_assets.dart       # Asset path constants
│   │   ├── theme/app_colors.dart           # Brand + semantic colours
│   │   ├── theme/app_tokens.dart           # Spacing, radii, text-styles
│   │   └── utils/
│   │       ├── background_backup.dart      # Workmanager callback dispatcher
│   │       ├── context_extensions.dart     # BuildContext helpers
│   │       └── hive_bootstrap.dart         # Hive init + adapter registration
│   ├── features/
│   │   └── expense/                        # ← all features currently here
│   │       ├── data/
│   │       │   ├── datasource/             # Raw Hive box read/write
│   │       │   ├── models/                 # Hive models + adapters
│   │       │   └── repositories/           # Hive repository implementations
│   │       ├── domain/
│   │       │   └── repositories/           # Abstract repository interfaces
│   │       └── presentation/
│   │           ├── provider/               # Riverpod providers / notifiers
│   │           ├── screens/                # Full-page screens
│   │           └── widgets/                # Reusable UI components
│   ├── routes/
│   │   └── app_routes.dart                 # ← Centralised navigation helpers
│   └── main.dart
├── pubspec.yaml
├── analysis_options.yaml
└── test/
    └── features/expense/               # Unit tests mirroring lib structure
```

---

## 2. File Classification

### Screens (`lib/features/expense/presentation/screens/`)
| File | Role |
|------|------|
| `app_shell.dart` | Root scaffold with IndexedStack + custom bottom nav |
| `home_screen.dart` | Dashboard: hero stats, date strip, recent transactions |
| `stats_screen.dart` | Monthly analytics with charts |
| `categories_screen.dart` | Spending by category + budget targets |
| `accounts_screen.dart` | Account list, balance overview, tools tab |
| `add_expense_screen.dart` | Create / edit a transaction (expense or income) |
| `records_history_screen.dart` | Full transaction history with filters |
| `transaction_search_screen.dart` | Fuzzy search across all transactions |
| `settings_screen.dart` | App preferences, theme, backup / restore |
| `onboarding_screen.dart` | First-run setup flow |
| `scanner_screen.dart` | QR / UPI barcode scanner → auto-fills AddExpense |
| `profile_screen.dart` | User profile (mostly placeholder) |
| `placeholder_screen.dart` | Generic "coming soon" stub |

### Widgets (`lib/features/expense/presentation/widgets/`)
| File | Role |
|------|------|
| `transaction_card.dart` | Single transaction row with swipe-to-delete |
| `expense_category.dart` | Category chip + icon helper |
| `account_editor_sheet.dart` | Bottom-sheet for create/edit account |
| `budget_editor_sheet.dart` | Bottom-sheet for set/edit category budget |
| `subscription_editor_sheet.dart` | Bottom-sheet for recurring subscriptions |
| `account_icons.dart` | Icon-key → IconData mapping for accounts |
| `subscription_icons.dart` | Icon-key → IconData for subscriptions |
| `quick_action_bar.dart` | Horizontal scrollable quick-action row |
| `power_pill_menu.dart` | Floating pill FAB with expandable actions |
| `app_drawer.dart` | Side drawer (Settings, profile header) |
| `amount_visibility.dart` | Privacy-mode aware amount display |
| `ui_feedback.dart` | Confirm dialog + bottom-sheet utilities |
| `recurring_tool_view.dart` | Recurring-subscription manager sub-view |
| `split_bill_tool_view.dart` | Bill-split calculator sub-view |

### Models (`lib/features/expense/data/models/`)
| File | Key Types |
|------|-----------|
| `expense_model.dart` | `ExpenseModel`, `TransactionType`, `ExpenseStats` |
| `account_model.dart` | `AccountModel` |
| `budget_model.dart` | `BudgetModel` |
| `recurring_subscription_model.dart` | `RecurringSubscriptionModel` |
| `app_preferences_model.dart` | `AppPreferencesModel` |

### Services / Datasources (`lib/features/expense/data/datasource/`)
| File | Hive Box |
|------|----------|
| `expense_local_datasource.dart` | `expenses` box |
| `account_local_datasource.dart` | `accounts` box |
| `budget_local_datasource.dart` | `budgets` box |
| `recurring_subscription_local_datasource.dart` | `recurring_subscriptions` box |
| `preferences_local_datasource.dart` | `preferences` box |
| `backup_local_datasource.dart` | JSON export/import helpers |

### Repositories
| Layer | Directory |
|-------|-----------|
| Interfaces (domain) | `lib/features/expense/domain/repositories/` |
| Implementations (data) | `lib/features/expense/data/repositories/` |

### Providers / State (`lib/features/expense/presentation/provider/`)
| File | Provides |
|------|---------|
| `expense_providers.dart` | `expenseListProvider`, `expenseControllerProvider`, `statsProvider`, `filteredExpensesProvider` |
| `account_providers.dart` | `accountListProvider`, `accountControllerProvider` |
| `budget_providers.dart` | `budgetTargetsProvider`, `budgetControllerProvider` |
| `preferences_providers.dart` | `appPreferencesProvider`, `appThemeModeProvider`, `localeProvider`, `currencySymbolProvider`, `privacyModeEnabledProvider`, `isOnboardingCompletedProvider` |
| `recurring_subscription_providers.dart` | `recurringSubscriptionListProvider`, `recurringSubscriptionControllerProvider` |
| `backup_providers.dart` | `backupControllerProvider`, `autoBackupEnabledProvider`, `backupFrequencyProvider`, `backupDirectoryPathProvider` |

### Core / Utils
| File | Purpose |
|------|---------|
| `lib/core/constants/app_assets.dart` | `AppAssets` – all asset paths |
| `lib/core/theme/app_colors.dart` | `AppColors` – all colour constants |
| `lib/core/theme/app_tokens.dart` | `AppSpacing`, `AppRadii`, `AppTextStyles` |
| `lib/core/utils/hive_bootstrap.dart` | `HiveBootstrap.initialize()` – registers all Hive adapters |
| `lib/core/utils/background_backup.dart` | `callbackDispatcher` for Workmanager |
| `lib/core/utils/context_extensions.dart` | `BuildContext` extension helpers |

### Routes
| File | Purpose |
|------|---------|
| `lib/routes/app_routes.dart` | `AppRoutes` – static navigation helpers for every pushed screen |

---

## 3. Navigation Map

```
AppShell (IndexedStack)
├── [0] HomeScreen
│        ├── push → TransactionSearchScreen
│        ├── push → AddExpenseScreen (new)
│        ├── push → AddExpenseScreen (edit)
│        └── push → RecordsHistoryScreen
│
├── [1] StatsScreen
│
├── [2] CategoriesScreen
│        └── push → AddExpenseScreen (new with category)
│
└── [3] AccountsScreen
         └── sheet → AccountEditorSheet

AppShell (Drawer)
└── push → SettingsScreen

AddExpenseScreen
└── child push → ScannerScreen
                └── pushReplacement → AddExpenseScreen (with parsed amount/note)
```

All `push` / `pushReplacement` calls are centralised through **`AppRoutes`** in `lib/routes/app_routes.dart`.

---

## 4. Key Dependencies

| Package | Use |
|---------|-----|
| `flutter_riverpod` | State management (providers + notifiers) |
| `hive` / `hive_flutter` | Local persistence |
| `fl_chart` | Charts in StatsScreen |
| `intl` | Date + currency formatting |
| `uuid` | ID generation |
| `mobile_scanner` | QR/barcode scanning |
| `workmanager` | Background backup scheduler |
| `file_picker` | Import backup file |
| `permission_handler` | Storage permission for backup |
| `share_plus` | Share backup file |
| `archive` | JSON compression for backups |
| `path_provider` | App documents path |

---

## 5. Identified Issues (at scan date)

| # | Issue | Severity | Location |
|---|-------|----------|----------|
| 1 | All domain features (accounts, settings, stats, categories) live under one `expense` feature folder | Medium | `/lib/features/expense/` |
| 2 | Large screen files with mixed UI + presentation logic | Medium | `home_screen.dart` (826 L), `add_expense_screen.dart` (797 L), `records_history_screen.dart` (789 L) |
| 3 | Navigation scattered inline across screens (pre-routes refactor) | Resolved | `app_routes.dart` created |
| 4 | No barrel (`index.dart`) exports → long relative import chains | Low | All directories |
| 5 | `app_shell.dart` contains `_CustomFloatingNavBar` private class — could be extracted | Low | `app_shell.dart` |
| 6 | `placeholder_screen.dart` unused in main navigation | Low | `presentation/screens/` |
| 7 | No `/assets/images` or `/assets/fonts` subdirectory organisation | Low | `/assets/` |

---

## 6. Refactor Plan Summary

### Done ✅
- Feature-first architecture under `/lib/features/expense/`
- Clean data / domain / presentation separation
- Riverpod for all state management
- Hive for local persistence with adapter registration in `HiveBootstrap`
- Centralised colours, spacing, radii in `core/theme/`
- Centralised navigation via `lib/routes/app_routes.dart`
- Barrel `index.dart` exports added to `screens/`, `widgets/`, `provider/`, `models/`, `theme/`, `utils/`

### Recommended Next Steps
1. **Split large screens** – extract sub-widgets out of `home_screen.dart`, `add_expense_screen.dart`, `records_history_screen.dart` (each >700 lines)
2. **Separate features** – move `accounts`, `analytics` (stats), `settings`, `categories` into their own feature folders under `/lib/features/`
3. **Extract `_CustomFloatingNavBar`** from `app_shell.dart` into `shared/widgets/`
4. **Organise assets** – create `/assets/images/`, `/assets/icons/`, `/assets/fonts/` subdirectories

---

## 7. Before / After Structure

### Before (pre-refactor)
```
/lib
  main.dart
  /core
    /constants
    /theme
    /utils
  /features
    /expense
      /data
        /datasource
        /models
        /repositories
      /domain
        /repositories
      /presentation
        /provider
        /screens   ← all 13 screens + app_shell mixed
        /widgets   ← all 14 widgets mixed
```

### After (post-refactor)
```
/lib
  main.dart
  /core
    /constants
      index.dart ← barrel export
    /theme
      app_colors.dart
      app_tokens.dart
      index.dart  ← barrel export
    /utils
      index.dart  ← barrel export
  /features
    /expense
      /data
        /datasource
        /models
          index.dart ← barrel export
        /repositories
      /domain
        /repositories
      /presentation
        /provider
          index.dart ← barrel export
        /screens
          index.dart ← barrel export
        /widgets
          index.dart ← barrel export
  /routes
    app_routes.dart ← centralised navigation
```

---

## 8. Change Log

| Date | Change | Files Affected |
|------|--------|----------------|
| 2026-04-04 | Created `memory.md` | `memory.md` |
| 2026-04-04 | Created `lib/routes/app_routes.dart` – centralised navigation helpers | `app_routes.dart`, `app_shell.dart`, `home_screen.dart`, `records_history_screen.dart`, `transaction_search_screen.dart`, `categories_screen.dart`, `app_drawer.dart`, `scanner_screen.dart` |
| 2026-04-04 | Added barrel `index.dart` exports | `screens/index.dart`, `widgets/index.dart`, `provider/index.dart`, `models/index.dart`, `theme/index.dart`, `utils/index.dart`, `constants/index.dart` |
