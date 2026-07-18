import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const primary = Color(0xFF6C63FF);
  static const primaryDark = Color(0xFF5A52E0);
  static const secondary = Color(0xFF8A7DFF);

  // Background
  static const background = Color(0xFFF8F9FD);
  static const surface = Colors.white;

  // Text
  static const textPrimary = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF64748B);
  static const hint = Color(0xFF94A3B8);

  // Borders
  static const border = Color(0xFFE5E7EB);

  // Status
  static const success = Color(0xFF22C55E);
  static const error = Color(0xFFEF4444);

  // Google
  static const googleRed = Color(0xFFEA4335);

  // Gradient
  static const gradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF8B7EFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
