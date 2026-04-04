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
│   ├── icon/                         # Launcher/splash build-time icons (app_icon.png, app_icon_fg.png, splash_mark.png)
│   └── images/                       # In-app runtime images (xpensa_logo.png)
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
│   │   ├── accounts/
│   │   │   └── accounts.dart                   # Re-export barrel for the accounts feature
│   │   ├── analytics/
│   │   │   └── analytics.dart                  # Re-export barrel for the analytics/stats feature
│   │   ├── categories/
│   │   │   └── categories.dart                 # Re-export barrel for the categories/budget feature
│   │   ├── settings/
│   │   │   └── settings.dart                   # Re-export barrel for the settings/prefs feature
│   │   └── expense/                            # Core expense feature (all data layer lives here)
│   │       ├── data/
│   │       │   ├── datasource/                 # Raw Hive box read/write
│   │       │   ├── models/                     # Hive models + adapters
│   │       │   └── repositories/               # Hive repository implementations
│   │       ├── domain/
│   │       │   └── repositories/               # Abstract repository interfaces
│   │       └── presentation/
│   │           ├── provider/                   # Riverpod providers / notifiers
│   │           ├── screens/                    # Full-page screens + per-screen subdirs
│   │           │   ├── home/                   # HomeHeader, HomeDateStrip, HomeMiscWidgets
│   │           │   ├── records_history/        # RecordsFilter, RecordsCards, etc.
│   │           │   ├── add_expense/            # AddExpenseWidgets
│   │           │   ├── stats/                  # StatsWidgets
│   │           │   ├── settings/               # SettingsWidgets
│   │           │   ├── accounts/               # AccountsWidgets + SliverAccountsTabView
│   │           │   └── categories/             # CategoriesWidgets
│   │           └── widgets/                    # Reusable UI components
│   ├── routes/
│   │   └── app_routes.dart                 # Centralised navigation helpers
│   ├── shared/
│   │   └── widgets/
│   │       └── floating_nav_bar.dart       # FloatingNavBar + NavBarItem (extracted from AppShell)
│   └── main.dart
├── pubspec.yaml
├── analysis_options.yaml
└── test/
    └── features/expense/               # Unit tests mirroring lib structure
```

---

## 2. File Classification

### Screens (`lib/features/expense/presentation/screens/`)

Each large screen has a dedicated subdirectory `screens/<name>/` containing extracted private-widget files.

| File | Role | Sub-widgets directory |
|------|------|-----------------------|
| `app_shell.dart` | Root scaffold with IndexedStack + custom bottom nav | — |
| `home_screen.dart` | Dashboard: hero stats, date strip, recent transactions | `home/` |
| `stats_screen.dart` | Monthly analytics with charts | `stats/` |
| `categories_screen.dart` | Spending by category + budget targets | `categories/` |
| `accounts_screen.dart` | Account list, balance overview, tools tab | `accounts/` |
| `add_expense_screen.dart` | Create / edit a transaction (expense or income) | `add_expense/` |
| `records_history_screen.dart` | Full transaction history with filters | `records_history/` |
| `transaction_search_screen.dart` | Fuzzy search across all transactions | — |
| `settings_screen.dart` | App preferences, theme, backup / restore | `settings/` |
| `onboarding_screen.dart` | First-run setup flow | — |
| `scanner_screen.dart` | QR / UPI barcode scanner → auto-fills AddExpense | — |
| `profile_screen.dart` | User profile (mostly placeholder) | — |
| `placeholder_screen.dart` | Generic "coming soon" stub | — |

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

### Shared Widgets (`lib/shared/widgets/`)
| File | Role |
|------|------|
| `floating_nav_bar.dart` | `FloatingNavBar` – pill-shaped bottom nav; `NavBarItem` – single animated tab |

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
| 1 | All domain features (accounts, settings, stats, categories) live under one `expense` feature folder | ~~Medium~~ Partially resolved: feature-namespace re-export barrels created in `lib/features/accounts/`, `analytics/`, `settings/`, `categories/`. Physical data-layer migration is future work. | `/lib/features/` |
| 2 | Large screen files with mixed UI + presentation logic | ~~Medium~~ Resolved: all screens ≤373 lines; private widget classes extracted into per-screen `screens/<name>/` subdirs. | — |
| 3 | Navigation scattered inline across screens (pre-routes refactor) | Resolved | `app_routes.dart` created |
| 4 | No barrel (`index.dart`) exports → long relative import chains | Resolved | All directories now have barrels |
| 5 | `app_shell.dart` contains `_CustomFloatingNavBar` private class — could be extracted | Resolved | `FloatingNavBar` → `shared/widgets/floating_nav_bar.dart` |
| 6 | `placeholder_screen.dart` unused in main navigation | Low | `presentation/screens/` |
| 7 | No `/assets/images` or `/assets/fonts` subdirectory organisation | Resolved | `/assets/images/xpensa_logo.png` created |

---

## 6. Refactor Plan Summary

### Done ✅
- Feature-first architecture under `/lib/features/expense/`
- Clean data / domain / presentation separation
- Riverpod for all state management
- Hive for local persistence with adapter registration in `HiveBootstrap`
- Centralised colours, spacing, radii in `core/theme/`
- Centralised navigation via `lib/routes/app_routes.dart`
- Barrel `index.dart` exports added to **all** directories:
  - `screens/`, `widgets/`, `provider/`, `models/`
  - `datasource/`, `data/repositories/`, `domain/repositories/`
  - `theme/`, `utils/`, `constants/`
  - `routes/`, `shared/widgets/`
- `FloatingNavBar` + `NavBarItem` extracted from `app_shell.dart` → `lib/shared/widgets/floating_nav_bar.dart`
- `lib/shared/widgets/` directory created for cross-feature UI components
- All large screens split into sub-widget directories (see §8 change log)
- `SliverAccountsTabView` extracted: `accounts_screen.dart` 563→57 L
- Feature-namespace barrels created: `accounts/`, `analytics/`, `settings/`, `categories/`
- Assets organised: `assets/images/` for runtime images, `assets/icon/` for build icons

### Recommended Next Steps (future sessions)
1. **Physical feature migration** – move providers and data layer files into the new feature namespaces (`lib/features/accounts/`, etc.) once `flutter analyze` is available to validate import changes
2. **Recurring subscriptions feature** – create `lib/features/recurring/` for the subscription models, providers, and editor sheet
3. **Add-expense flow** – consider extracting a `lib/features/transactions/` feature for `add_expense_screen`, `records_history_screen`, and `transaction_search_screen`

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
        /screens   ← all 13 screens + app_shell + _FloatingNavBar mixed (263 lines)
        /widgets   ← all 14 widgets mixed
```

### After (post-refactor)
```
/lib
  main.dart
  /core
    /constants
      index.dart
    /theme
      app_colors.dart
      app_tokens.dart
      index.dart
    /utils
      index.dart
  /features
    /expense
      /data
        /datasource
          index.dart
        /models
          index.dart
        /repositories
          index.dart
      /domain
        /repositories
          index.dart
      /presentation
        /provider
          index.dart
        /screens
          index.dart    ← app_shell now 127 lines (clean shell only)
        /widgets
          index.dart
  /routes
    app_routes.dart
    index.dart
  /shared
    /widgets
      floating_nav_bar.dart   ← FloatingNavBar + NavBarItem (extracted)
      index.dart
```

---

## 8. Change Log

| Date | Change | Files Affected |
|------|--------|----------------|
| 2026-04-04 | Created `memory.md` | `memory.md` |
| 2026-04-04 | Created `lib/routes/app_routes.dart` – centralised navigation helpers | `app_routes.dart`, `app_shell.dart`, `home_screen.dart`, `records_history_screen.dart`, `transaction_search_screen.dart`, `categories_screen.dart`, `app_drawer.dart`, `scanner_screen.dart` |
| 2026-04-04 | Added barrel `index.dart` exports (screens, widgets, provider, models, theme, utils, constants) | 7 files |
| 2026-04-04 | Extracted `FloatingNavBar` + `NavBarItem` from `app_shell.dart` → `lib/shared/widgets/floating_nav_bar.dart`; `app_shell.dart` reduced from 263 to 127 lines | `app_shell.dart`, `floating_nav_bar.dart` |
| 2026-04-04 | Added barrel `index.dart` exports for remaining directories (datasource, data/repositories, domain/repositories, routes, shared/widgets) | 5 files |
| 2026-04-04 | Organized assets: moved `xpensa_logo.png` from `assets/icon/` → `assets/images/`; updated `AppAssets.logo` + `pubspec.yaml` flutter assets block | `assets/images/xpensa_logo.png`, `app_assets.dart`, `pubspec.yaml` |
| 2026-04-04 | Fixed `home_screen.dart` merge artifacts: duplicate `accountsMap`/`accountMap` variable, duplicate `accountLabel:` param, unreachable `return` | `home_screen.dart` |
| 2026-04-04 | Split `home_screen.dart` 810→337 L: extracted `HomeHeader`, `HomeMetricColumn`, `formatSignedCurrencyForHome`, `HomeDateStrip`, `HomeDateNavButton`, `HomeDayPill`, `HomeEmptyCard`, `HomeAmountChip` | `screens/home/home_header.dart`, `screens/home/home_date_strip.dart`, `screens/home/home_misc_widgets.dart` |
| 2026-04-04 | Split `records_history_screen.dart` 786→276 L + fixed severe merge artifacts (two parallel build/filter implementations): extracted `RecordsSummaryCard`, `RecordsStateCard`, `RecordsFilterChips`, `RecordsAccountDropdown`, `RecordsExpenseList`, `RecordsFilter` enum | `screens/records_history/records_cards.dart`, `records_filter_bar.dart`, `records_expense_list.dart`, `records_filter.dart` |
| 2026-04-04 | Split `add_expense_screen.dart` 797→598 L: extracted `AddExpenseTopButton`, `AddExpenseModeTab`, `AddExpenseInfoCapsule`, `AddExpenseSelectionCapsule`, `AddExpenseKeypadButton`, `TransactionTypeX` extension | `screens/add_expense/add_expense_widgets.dart` |
| 2026-04-04 | Split `stats_screen.dart` 427→267 L: extracted `StatsMetricTile`, `StatsBreakdownCard` | `screens/stats/stats_widgets.dart` |
| 2026-04-04 | Split `settings_screen.dart` 446→373 L: extracted `SettingsSectionHeader`, `SettingsCard`, `SettingsTileIcon` | `screens/settings/settings_widgets.dart` |
| 2026-04-04 | Split `accounts_screen.dart` 563→286 L: extracted `AccountsToolsTabView`, `AccountsPillSwitch`, `AccountsSummaryChip`, `AccountCard`, `EmptyAccountsCard` | `screens/accounts/accounts_widgets.dart` |
| 2026-04-04 | Split `categories_screen.dart` 490→257 L: extracted `CategoriesPillSwitch`, `CategoryGridCard`, `AddCategoryCard`, `CategoryGridData` | `screens/categories/categories_widgets.dart` |
| 2026-04-04 | Extracted `SliverAccountsTabView` as ConsumerWidget → `screens/accounts/accounts_widgets.dart`; stripped 14 redundant imports from `accounts_screen.dart`; `accounts_screen.dart` reduced to 57 lines | `accounts_screen.dart`, `accounts/accounts_widgets.dart` |
| 2026-04-04 | Updated `screens/index.dart` barrel to also export all per-screen sub-widget files | `screens/index.dart` |
| 2026-04-04 | Created feature-namespace re-export barrels: `lib/features/accounts/accounts.dart`, `analytics/analytics.dart`, `settings/settings.dart`, `categories/categories.dart` | 4 new files |
