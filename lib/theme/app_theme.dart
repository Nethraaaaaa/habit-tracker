import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette (from liquidink.design 2024)
  static const Color primaryBackground = Color(0xFFFFFFFF);
  static const Color secondaryBackground = Color(0xFFF8F9FA);
  static const Color tertiaryBackground = Color(0xFFF1F3F4);
  
  // Warm grays for secondary backgrounds
  static const Color warmGrayLight = Color(0xFFF5F5F5);
  static const Color warmGrayMedium = Color(0xFFE8E8E8);
  
  // Accent Colors
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentCoral = Color(0xFFFF8A65);
  static const Color accentRed = Color(0xFFE57373);
  
  // Supporting Colors
  static const Color accentBlue = Color(0xFF64B5F6);
  static const Color accentPurple = Color(0xFFBA68C8);
  static const Color accentGreen = Color(0xFF81C784);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textInverse = Color(0xFFFFFFFF);
  
  // Glassmorphism Colors
  static const Color glassBackground = Color(0x99FFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassShadow = Color(0x1A000000);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [accentOrange, accentCoral],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [accentBlue, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [accentGreen, Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [primaryBackground, secondaryBackground],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient glassGradient = LinearGradient(
    colors: [glassBackground, Color(0xCCFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Animated Gradients
  static const LinearGradient animatedGradient1 = LinearGradient(
    colors: [accentOrange, accentCoral, accentRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient animatedGradient2 = LinearGradient(
    colors: [accentBlue, accentPurple, accentCoral],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // Glassmorphism Shadows
  static const List<BoxShadow> glassShadowSmall = [
    BoxShadow(
      color: glassShadow,
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> glassShadowMedium = [
    BoxShadow(
      color: glassShadow,
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> glassShadowLarge = [
    BoxShadow(
      color: glassShadow,
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];
  
  // Neon Glow Effects
  static const List<BoxShadow> neonGlowOrange = [
    BoxShadow(
      color: Color(0x40FF6B35),
      blurRadius: 12,
      offset: Offset(0, 0),
      spreadRadius: 2,
    ),
  ];
  
  static const List<BoxShadow> neonGlowBlue = [
    BoxShadow(
      color: Color(0x4064B5F6),
      blurRadius: 12,
      offset: Offset(0, 0),
      spreadRadius: 2,
    ),
  ];
  
  static const List<BoxShadow> neonGlowGreen = [
    BoxShadow(
      color: Color(0x4081C784),
      blurRadius: 12,
      offset: Offset(0, 0),
      spreadRadius: 2,
    ),
  ];
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusPill = 50.0;
  static const double radiusCircular = 100.0;
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Typography - Modern Font Stack
  static const String fontFamily = 'Inter';
  
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.25,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.15,
  );
  
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.15,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.15,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.1,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.15,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.1,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: 0.1,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    letterSpacing: 0.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    letterSpacing: 0.25,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    letterSpacing: 0.4,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.1,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.5,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    letterSpacing: 0.5,
  );
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 800);
  
  // Animation Curves
  static const Curve curveEaseOut = Curves.easeOutCubic;
  static const Curve curveEaseInOut = Curves.easeInOutCubic;
  static const Curve curveBounce = Curves.elasticOut;
  
  // Glassmorphism Decoration
  static BoxDecoration glassDecoration = BoxDecoration(
    gradient: glassGradient,
    borderRadius: BorderRadius.circular(radiusLarge),
    border: Border.all(
      color: glassBorder,
      width: 1.0,
    ),
    boxShadow: glassShadowMedium,
  );
  
  static BoxDecoration glassDecorationSmall = BoxDecoration(
    gradient: glassGradient,
    borderRadius: BorderRadius.circular(radiusMedium),
    border: Border.all(
      color: glassBorder,
      width: 1.0,
    ),
    boxShadow: glassShadowSmall,
  );
  
  static BoxDecoration glassDecorationLarge = BoxDecoration(
    gradient: glassGradient,
    borderRadius: BorderRadius.circular(radiusXLarge),
    border: Border.all(
      color: glassBorder,
      width: 1.0,
    ),
    boxShadow: glassShadowLarge,
  );
} 