import 'package:flutter/material.dart';

/// Colors used throughout the application.
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF5F67EA);
  static const Color primaryLight = Color(0xFF8286EF);
  static const Color primaryDark = Color(0xFF4A4DC6);
  
  // Background colors
  static const Color background = Color(0xFFF2F2F2);
  static const Color cardBackground = Colors.white;
  static const Color darkBackground = Color(0xFF121212);
  
  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6E6E6E);
  static const Color textLight = Color(0xFFB1B1B1);
  static const Color textOnPrimary = Colors.white;
  
  // Action colors
  static const Color error = Color(0xFFE74C3C);
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF1C40F);
  static const Color info = Color(0xFF3498DB);
  
  // Icon colors
  static const Color iconActive = primary;
  static const Color iconInactive = Color(0xFFBDBDBD);
  
  // Specific feature colors
  static const Color favorite = Color(0xFFE74C3C);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);
  
  // Chart-specific colors
  static const Color singleChart = Color(0xFF00C6AE);
  static const Color albumChart = Color(0xFF6C60FF);
  
  // Genre colors - for visual variety in genre tags
  static const List<Color> genreColors = [
    Color(0xFF5F67EA),  // Primary
    Color(0xFF00C6AE),  // Teal
    Color(0xFFFF71CE),  // Pink
    Color(0xFFFFD670),  // Yellow
    Color(0xFF01BEFE),  // Blue
  ];
  
  // Gradient colors for featured content
  static const Gradient featuredGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5F67EA),
      Color(0xFF6C60FF),
    ],
  );
}