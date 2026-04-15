import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import 'settings/settings_widgets.dart';
import '../../../../core/utils/context_extensions.dart';
import '../provider/account_providers.dart';
import '../provider/backup_providers.dart';
import '../provider/budget_providers.dart';
import '../provider/expense_providers.dart';
import '../provider/preferences_providers.dart';
import '../provider/recurring_subscription_providers.dart';
import '../widgets/ui_feedback.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(appPreferencesControllerProvider);
    final backupController = ref.read(backupControllerProvider);

    final smartReminders = ref.watch(smartRemindersEnabledProvider);
    final privacyMode = ref.watch(privacyModeEnabledProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(localeProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);

    // Backup states
    final autoBackup = ref.watch(autoBackupEnabledProvider);
    final backupFrequency = ref.watch(backupFrequencyProvider);
    final backupPath = ref.watch(backupDirectoryPathProvider);
    final lastBackup = ref.watch(lastBackupDateTimeProvider);

    final lastBackupText = lastBackup != null
        ? DateFormat('MMM d, yyyy HH:mm').format(lastBackup)
        : 'Never';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textDark,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── General ──────────────────────────────────────────────────
            const SettingsSectionHeader(title: 'General'),
            SettingsCard(
              children: [
                _buildThemeTile(context, themeMode, controller),
                _buildCurrencyTile(context, currencySymbol, controller),
                _buildLanguageTile(context, locale, controller),
              ],
            ),
            const SizedBox(height: 24),

            // ── Notifications ─────────────────────────────────────────────
            const SettingsSectionHeader(title: 'Notifications'),
            SettingsCard(
              children: [
                _buildToggleTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Smart Reminders',
                  subtitle: 'Gentle nudges for pending bills',
                  value: smartReminders,
                  onChanged: controller.setSmartReminders,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Security & Privacy ────────────────────────────────────────
            const SettingsSectionHeader(title: 'Security & Privacy'),
            SettingsCard(
              children: [
                _buildToggleTile(
                  icon: Icons.security_outlined,
                  title: 'Privacy Mode',
                  subtitle: 'Mask balances across the app',
                  value: privacyMode,
                  onChanged: controller.setPrivacyMode,
                ),
                _buildComingSoonTile(
                  context,
                  icon: Icons.fingerprint_rounded,
                  title: 'Biometric Lock',
                  subtitle: 'Secure the app with fingerprint or face ID',
                ),
                _buildComingSoonTile(
                  context,
                  icon: Icons.pin_outlined,
                  title: 'PIN Lock',
                  subtitle: 'Protect the app with a 4-digit PIN',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Data Management ───────────────────────────────────────────
            const SettingsSectionHeader(title: 'Data Management'),
            SettingsCard(
              children: [
                _buildActionTile(
                  icon: Icons.cloud_upload_outlined,
                  title: 'Export Data',
                  subtitle: 'Create a local backup file (.xpensa)',
                  onTap: () async {
                    try {
                      await backupController.exportData();
                    } catch (e) {
                      if (context.mounted) {
                        context.showSnackBar('Export failed: $e');
                      }
                    }
                  },
                ),
                _buildActionTile(
                  icon: Icons.cloud_download_outlined,
                  title: 'Import Data',
                  subtitle: 'Restore from a backup file',
                  onTap: () async {
                    final confirmed = await confirmDestructiveAction(
                      context,
                      title: 'Restore Data?',
                      message:
                          'This will overwrite your current transactions. This action cannot be undone.',
                      confirmLabel: 'Restore',
                    );

                    if (confirmed) {
                      try {
                        final success = await backupController.importData();
                        if (success && context.mounted) {
                          context.showSnackBar('Data restored successfully!');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          context.showSnackBar('Import failed: $e');
                        }
                      }
                    }
                  },
                ),
                _buildToggleTile(
                  icon: Icons.history_rounded,
                  title: 'Auto Backup',
                  subtitle: 'Scheduled offline backups',
                  value: autoBackup,
                  onChanged: (val) async {
                    if (val && backupPath == null) {
                      final picked = await _pickBackupDirectory(context, ref);
                      if (picked == null) return;
                    }
                    controller.setAutoBackup(val);
                  },
                ),
                if (autoBackup) ...[
                  _buildSelectionTile(
                    icon: Icons.timer_outlined,
                    title: 'Backup Frequency',
                    subtitle: 'Current: ${backupFrequency.toUpperCase()}',
                    value: backupFrequency,
                    onChanged: (val) {
                      if (val != null) controller.setBackupFrequency(val);
                    },
                    items: const [
                      DropdownMenuItem(value: 'daily', child: Text('Daily')),
                      DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                      DropdownMenuItem(
                          value: 'monthly', child: Text('Monthly')),
                    ],
                  ),
                  _buildActionTile(
                    icon: Icons.folder_open_rounded,
                    title: 'Backup Location',
                    subtitle: backupPath ?? 'Not set',
                    onTap: () => _pickBackupDirectory(context, ref),
                  ),
                ],
                ListTile(
                  leading: const SettingsTileIcon(icon: Icons.update_rounded),
                  title: const Text(
                    'Last Backup',
                    style: TextStyle(
                        color: AppColors.textDark, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    lastBackupText,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── App Management ────────────────────────────────────────────
            const SettingsSectionHeader(title: 'App Management'),
            SettingsCard(
              children: [
                _buildDangerTile(
                  icon: Icons.delete_sweep_outlined,
                  title: 'Reset App Data',
                  subtitle:
                      'Permanently erase all transactions and accounts',
                  onTap: () => _resetAppData(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── About ─────────────────────────────────────────────────────
            const SettingsSectionHeader(title: 'About'),
            SettingsCard(
              children: [
                _buildActionTile(
                  icon: Icons.info_outline_rounded,
                  title: 'App Version',
                  subtitle: '2.0.0',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'XPensa',
                      applicationVersion: '2.0.0',
                      applicationLegalese:
                          '© 2025 XPensa. Offline-first expense tracking.',
                    );
                  },
                ),
                _buildActionTile(
                  icon: Icons.description_outlined,
                  title: 'About This Project',
                  subtitle: 'Learn more about XPensa',
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'XPensa',
                    applicationVersion: '2.0.0',
                    children: const <Widget>[
                      Text(
                        'XPensa is an offline-first personal finance tracker '
                        'built for Android. Track expenses, manage accounts, '
                        'plan budgets, and more — all on your device, no '
                        'cloud required.',
                        style: TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                ),
                _buildActionTile(
                  icon: Icons.support_agent_outlined,
                  title: 'Support',
                  subtitle: 'Get help or report an issue',
                  onTap: () => showPlannedFeatureNotice(
                    context,
                    title: 'Support',
                    message:
                        'In-app support is coming soon. For now, please reach out via the developer page or GitHub issues.',
                  ),
                ),
                _buildActionTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Developer Page',
                  subtitle: 'Visit the project repository',
                  onTap: () => showPlannedFeatureNotice(
                    context,
                    title: 'Developer Page',
                    message:
                        'XPensa is an open-source project. The GitHub link will be available in an upcoming update.',
                  ),
                ),
                _buildActionTile(
                  icon: Icons.policy_outlined,
                  title: 'Privacy Policy & Terms',
                  subtitle: 'How we handle your data',
                  onTap: () => showPlannedFeatureNotice(
                    context,
                    title: 'Privacy Policy',
                    message:
                        'XPensa stores all data locally on your device. No data is ever sent to any server or third party.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetAppData(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmDestructiveAction(
      context,
      title: 'Reset All Data?',
      message:
          'This will permanently delete all transactions, accounts, '
          'subscriptions, and budgets. Your settings will be preserved. '
          'This cannot be undone.',
      confirmLabel: 'Reset Everything',
    );
    if (!confirmed || !context.mounted) return;

    try {
      await ref.read(backupControllerProvider).resetAllData();
      ref.invalidate(expenseListProvider);
      ref.invalidate(accountListProvider);
      ref.invalidate(budgetTargetsProvider);
      ref.invalidate(recurringSubscriptionListProvider);
      if (context.mounted) {
        context.showSnackBar('All data has been reset.');
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar('Reset failed: $e');
      }
    }
  }

  Future<String?> _pickBackupDirectory(
      BuildContext context, WidgetRef ref) async {
    // Request permission first
    final status = await Permission.storage.request();
    if (!status.isGranted && !status.isLimited) {
      if (context.mounted) {
        context.showSnackBar(
            'Storage permission is required for auto-backups.');
      }
      return null;
    }

    final path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      ref.read(appPreferencesControllerProvider).setBackupDirectory(path);
    }
    return path;
  }

  Widget _buildSelectionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required ValueChanged<String?> onChanged,
    required List<DropdownMenuItem<String>> items,
  }) {
    return ListTile(
      leading: SettingsTileIcon(icon: icon),
      title: Text(
        title,
        style: const TextStyle(
            color: AppColors.textDark, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        onChanged: onChanged,
        items: items,
      ),
    );
  }

  Widget _buildThemeTile(
    BuildContext context,
    ThemeMode currentMode,
    AppPreferencesController controller,
  ) {
    return ListTile(
      leading: const SettingsTileIcon(icon: Icons.palette_outlined),
      title: const Text(
        'Appearance',
        style: TextStyle(
            color: AppColors.textDark, fontWeight: FontWeight.w700),
      ),
      trailing: DropdownButton<String>(
        value: currentMode.name,
        underline: const SizedBox(),
        onChanged: (value) {
          if (value != null) {
            controller.setThemeMode(value);
          }
        },
        items: const [
          DropdownMenuItem(value: 'light', child: Text('Light')),
          DropdownMenuItem(value: 'dark', child: Text('Dark')),
          DropdownMenuItem(value: 'system', child: Text('System')),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    String currentLocale,
    AppPreferencesController controller,
  ) {
    return ListTile(
      leading: const SettingsTileIcon(icon: Icons.language_rounded),
      title: const Text(
        'Language',
        style: TextStyle(
            color: AppColors.textDark, fontWeight: FontWeight.w700),
      ),
      trailing: DropdownButton<String>(
        value: currentLocale,
        underline: const SizedBox(),
        onChanged: (value) {
          if (value != null) {
            controller.setLocale(value);
          }
        },
        items: const [
          DropdownMenuItem(value: 'en_IN', child: Text('English (IN)')),
          DropdownMenuItem(value: 'en_US', child: Text('English (US)')),
          DropdownMenuItem(value: 'hi_IN', child: Text('हिन्दी')),
        ],
      ),
    );
  }

  Widget _buildCurrencyTile(
    BuildContext context,
    String currentCurrency,
    AppPreferencesController controller,
  ) {
    return ListTile(
      leading: const SettingsTileIcon(icon: Icons.payments_outlined),
      title: const Text(
        'Currency',
        style: TextStyle(
            color: AppColors.textDark, fontWeight: FontWeight.w700),
      ),
      trailing: DropdownButton<String>(
        value: currentCurrency,
        underline: const SizedBox(),
        onChanged: (value) {
          if (value != null) {
            controller.setCurrencySymbol(value);
          }
        },
        items: const [
          DropdownMenuItem(value: '\u20B9', child: Text('Rupee (\u20B9)')),
          DropdownMenuItem(value: '\$', child: Text('Dollar (\$)')),
          DropdownMenuItem(value: '\u20AC', child: Text('Euro (\u20AC)')),
          DropdownMenuItem(value: '\u00A3', child: Text('Pound (\u00A3)')),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: SettingsTileIcon(icon: icon),
      title: Text(
        title,
        style: const TextStyle(
            color: AppColors.textDark, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: SettingsTileIcon(icon: icon),
      title: Text(
        title,
        style: const TextStyle(
            color: AppColors.textDark, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
      trailing:
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      onTap: onTap,
    );
  }

  /// A tile whose action is not yet available. Tapping shows a planned-feature
  /// notice. A pill badge is shown instead of a chevron.
  Widget _buildComingSoonTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: SettingsTileIcon(icon: icon),
      title: Text(
        title,
        style: const TextStyle(
            color: AppColors.textDark, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceAccent,
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        child: const Text(
          'Soon',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      onTap: () => showPlannedFeatureNotice(
        context,
        title: title,
        message: 'This security feature is coming in a future update.',
      ),
    );
  }

  /// A destructive action tile with red accent colours.
  Widget _buildDangerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.danger, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
            color: AppColors.danger, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.danger),
      onTap: onTap,
    );
  }
}
