import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';

class PowerPillMenu extends StatelessWidget {
  final VoidCallback onVoice;
  final VoidCallback onSplit;
  final VoidCallback onScanner;
  final VoidCallback onClose;

  const PowerPillMenu({
    super.key,
    required this.onVoice,
    required this.onSplit,
    required this.onScanner,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: AppColors.overlayScrim,
        child: Stack(
          children: [
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuItem(
                      icon: Icons.mic_none_rounded,
                      label: 'Voice',
                      statusLabel: 'Soon',
                      onTap: null,
                      delay: 0,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildMenuItem(
                      icon: Icons.call_split_rounded,
                      label: 'Split',
                      statusLabel: 'Soon',
                      onTap: null,
                      delay: 50,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildMenuItem(
                      icon: Icons.qr_code_scanner_rounded,
                      label: 'Scanner',
                      onTap: () {
                        onScanner();
                        onClose();
                      },
                      delay: 100,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required int delay,
    String? statusLabel,
  }) {
    final isEnabled = onTap != null;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 200 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          FloatingActionButton.small(
            onPressed: onTap,
            backgroundColor:
                isEnabled ? Colors.white : AppColors.surfaceDisabled,
            foregroundColor:
                isEnabled ? AppColors.primaryBlue : AppColors.disabledContent,
            child: Icon(icon),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (statusLabel != null) ...<Widget>[
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.overlayWhiteSoft,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              child: Text(
                statusLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PowerPill extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const PowerPill({
    super.key,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        onLongPress();
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.3),
              blurRadius: AppSpacing.sm,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
