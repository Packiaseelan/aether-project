import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography hierarchy for Project Aether.
abstract class AppTextStyles {
  static const TextStyle countdownTimer = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 32,
    fontFamily: 'monospace',
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingMedium = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle sectionLabel = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle raidStatus = TextStyle(
    color: AppColors.danger,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );

  static const TextStyle bodySmall = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
  );

  static const TextStyle caption = TextStyle(
    color: AppColors.accent,
    fontSize: 9,
  );

  static const TextStyle buttonText = TextStyle(
    color: AppColors.textAction,
    fontWeight: FontWeight.bold,
  );
}
