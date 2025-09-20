import 'package:flutter/material.dart';

class AppTheme {
  // Define bright and vibrant color scheme
  static const Color primaryColor = Color(0xFF42A6EC); // Bright Blue
  static const Color primaryContainer = Color(0xFFE3F2FD);
  static const Color secondary = Color(0xFF4CAF50); // Fresh Green
  static const Color secondaryContainer = Color(0xFFE8F5E8);
  static const Color tertiary = Color(0xFFFF9800); // Vibrant Orange
  static const Color tertiaryContainer = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFF44336);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color outline = Color(0xFFBDBDBD);
  static const Color outlineVariant = Color(0xFFE0E0E0);
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color inverseSurface = Color(0xFF37474F);
  static const Color inverseOnSurface = Color(0xFFECEFF1);
  static const Color inversePrimary = Color(0xFF64B5F6);
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
  static const Color surfaceTint = Color(0xFF2196F3);

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Color(0xFF0D47A1),
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: Color(0xFF2E7D32),
      tertiary: tertiary,
      onTertiary: Colors.white,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: Color(0xFFE65100),
      error: error,
      onError: Colors.white,
      errorContainer: errorContainer,
      onErrorContainer: Color(0xFFB71C1C),
      background: surface,
      onBackground: Color(0xFF212121),
      surface: surface,
      onSurface: Color(0xFF212121),
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: Color(0xFF424242),
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
      surfaceTint: surfaceTint,
    ),
    
    // AppBar theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: surface,
      foregroundColor: Color(0xFF212121),
      surfaceTintColor: surfaceTint,
    ),
    
    // Card theme
    cardTheme: const CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    
    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Filled button theme
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    // FAB theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(),
      elevation: 3,
      backgroundColor: primaryColor, // Use primary color for FAB
      foregroundColor: Colors.white,
    ),
    
    // Navigation bar theme
    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      backgroundColor: surface,
      surfaceTintColor: surfaceTint,
      indicatorColor: primaryContainer,
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
    
    // List tile theme
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
    
    // Dialog theme
    dialogTheme: const DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      elevation: 6,
    ),
    
    // Bottom sheet theme
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      elevation: 8,
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Color(0xFF64B5F6), // Light blue for dark theme
      onPrimary: Color(0xFF0D47A1),
      primaryContainer: Color(0xFF1976D2),
      onPrimaryContainer: Color(0xFFE3F2FD),
      secondary: Color(0xFF81C784), // Light green for dark theme
      onSecondary: Color(0xFF2E7D32),
      secondaryContainer: Color(0xFF388E3C),
      onSecondaryContainer: Color(0xFFE8F5E8),
      tertiary: Color(0xFFFFB74D), // Light orange for dark theme
      onTertiary: Color(0xFFE65100),
      tertiaryContainer: Color(0xFFF57C00),
      onTertiaryContainer: Color(0xFFFFF3E0),
      error: Color(0xFFEF5350),
      onError: Color(0xFFB71C1C),
      errorContainer: Color(0xFFD32F2F),
      onErrorContainer: Color(0xFFFFEBEE),
      background: Color(0xFF121212), // Dark background
      onBackground: Color(0xFFE0E0E0),
      surface: Color(0xFF1E1E1E), // Dark surface
      onSurface: Color(0xFFE0E0E0),
      surfaceVariant: Color(0xFF2A2A2A),
      onSurfaceVariant: Color(0xFFBDBDBD),
      outline: Color(0xFF757575),
      outlineVariant: Color(0xFF424242),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE0E0E0),
      onInverseSurface: Color(0xFF121212),
      inversePrimary: Color(0xFF2196F3),
      surfaceTint: Color(0xFF64B5F6),
    ),
    
    // Apply same theme configurations for dark mode
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Color(0xFFE0E0E0),
      surfaceTintColor: Color(0xFF64B5F6),
    ),
    
    cardTheme: const CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF757575)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF64B5F6), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF5350)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF5350), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(),
      elevation: 3,
      backgroundColor: Color(0xFF81C784), // Green FAB for dark theme
      foregroundColor: Color(0xFF2E7D32),
    ),
    
    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      backgroundColor: const Color(0xFF1E1E1E),
      surfaceTintColor: const Color(0xFF64B5F6),
      indicatorColor: const Color(0xFF1976D2),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
    
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
    
    dialogTheme: const DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      elevation: 6,
    ),
    
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      elevation: 8,
    ),
  );
}