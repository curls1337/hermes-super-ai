import 'package:flutter/material.dart';

class VisionTokens {
  // Canvas & Surfaces
  static const Color bgSpatialCanvas = Color(0xFF090D16);
  static const Color bgGraphiteDeep = Color(0xFF0B0F19);
  static const Color bgGraphiteElevated = Color(0xFF111827);
  static const Color bgGraphiteSurface = Color(0xFF1E293B);

  // Alabaster Light Theme
  static const Color bgAlabasterCanvas = Color(0xFFF1F5F9);
  static const Color bgAlabasterCard = Color(0xFFFFFFFF);

  // Brand Accents
  static const Color accentCyan = Color(0xFF38BDF8);
  static const Color accentIndigo = Color(0xFF6366F1);
  static const Color accentViolet = Color(0xFF818CF8);
  static const Color accentPurple = Color(0xFFA855F7);

  // Semantic Colors
  static const Color colorSuccess = Color(0xFF10B981);
  static const Color colorWarning = Color(0xFFF59E0B);
  static const Color colorDanger = Color(0xFFEF4444);

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textDarkPrimary = Color(0xFF0F172A);
  static const Color textDarkSecondary = Color(0xFF475569);

  // Radii
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;

  static LinearGradient prismGradient = const LinearGradient(
    colors: [accentCyan, accentViolet, Color(0xFFC084FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
