import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF0D9488); // Teal-cyan modern primary
  static const Color primaryDark = Color(0xFF14B8A6);
  static const Color secondary = Color(0xFF6366F1); // Indigo accent
  static const Color accent = Color(0xFFF59E0B); // Amber warning/attention

  // Status colors
  static const Color statusActive = Color(0xFF10B981); // Emerald green
  static const Color statusInactive = Color(0xFF64748B); // Slate
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusError = Color(0xFFEF4444);

  // Surface colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);

  // Status preset color palette
  static const List<int> presetColors = [
    0xFF0D9488, // Teal
    0xFF3B82F6, // Blue
    0xFF6366F1, // Indigo
    0xFF8B5CF6, // Purple
    0xFFEC4899, // Pink
    0xFFEF4444, // Red
    0xFFF97316, // Orange
    0xFFF59E0B, // Amber
    0xFF10B981, // Emerald
    0xFF64748B, // Slate
  ];
}

