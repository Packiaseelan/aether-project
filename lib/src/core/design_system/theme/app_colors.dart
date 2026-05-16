import 'package:flutter/material.dart';

/// Semantic colors for Project Aether.
/// Standardized to eliminate inline hex and material color direct access.
abstract class AppColors {
  static const Color background = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF212121); // Equivalent to Colors.grey[900]
  static const Color cardBackground = Colors.black87;
  
  static const Color primary = Colors.orangeAccent;
  static const Color accent = Colors.blueAccent;
  static const Color danger = Colors.redAccent;
  static const Color success = Colors.green;
  
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textTertiary = Colors.white54;
  static const Color textAction = Colors.black;

  static const Color divider = Colors.white10;
  static const Color progressBackground = Color(0xFF424242); // Equivalent to Colors.grey[800]
}
