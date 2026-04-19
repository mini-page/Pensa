import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A compact, pill-shaped boolean toggle used consistently across all screens.
///
/// Visual spec (matches the category-screen toggle):
///   • Track: 42 × 24 dp, fully rounded
///   • Thumb: 18 × 18 dp white circle with a subtle shadow
///   • On  → track fills with [activeColor]
///   • Off → track fills with [AppColors.backgroundLight]
///
/// Centralising this widget means a single edit here propagates the size and
/// appearance to every toggle in the app (Settings, SMS sheet, Power FAB, etc.).
class AppToggleSwitch extends StatelessWidget {
  const AppToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = AppColors.primaryBlue,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  /// Track colour when the toggle is on. Defaults to [AppColors.primaryBlue].
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: value,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 42,
          height: 24,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? activeColor : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(999),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 160),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
