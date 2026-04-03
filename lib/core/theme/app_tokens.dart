import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double fabOffset = 92;
}

class AppRadii {
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 28;
  static const double hero = 32;
  static const double sheet = 44;
  static const double pill = 99;
}

class AppTextStyles {
  static const TextStyle sectionHeading = TextStyle(
    color: AppColors.textDark,
    fontSize: 20,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle sectionSubtitle = TextStyle(
    color: AppColors.textMuted,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyStrong = TextStyle(
    color: AppColors.textDark,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle bodyMuted = TextStyle(
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle cardValue = TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle eyebrowOnDark = TextStyle(
    color: AppColors.overlayWhiteStrong,
    fontSize: 10,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.1,
  );
}
