import 'package:flutter/material.dart';

class AppTheme {
  // Light theme colors
  static final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6A3DE8),
    secondary: const Color(0xFFFF7B54),
    tertiary: const Color(0xFF3ECCAB),
    brightness: Brightness.light,
  );

  // Dark theme colors
  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6A3DE8),
    secondary: const Color(0xFFFF9678),
    tertiary: const Color(0xFF4FDDBF),
    brightness: Brightness.dark,
    surface: const Color(0xFF1E1E1E),
  );

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    colorScheme: _lightColorScheme,
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Updated AppBar theme for Material 3
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: _lightColorScheme.surface.withValues(alpha: 0.95),
      foregroundColor: _lightColorScheme.onSurface,
      scrolledUnderElevation: 0.5,
    ),
    
    scaffoldBackgroundColor: _lightColorScheme.surface,
    
    // Updated Card theme for Material 3
    cardTheme: CardTheme(
      color: _lightColorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Updated ListTileTheme for Material 3
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    
    // Updated Segmented Button theme
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return _lightColorScheme.primaryContainer;
          }
          return _lightColorScheme.surfaceContainerHighest;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return _lightColorScheme.onPrimaryContainer;
          }
          return _lightColorScheme.onSurfaceVariant;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    
    fontFamily: 'Poppins',
    
    // Updated Button theme for Material 3
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: _lightColorScheme.primaryContainer,
        foregroundColor: _lightColorScheme.onPrimaryContainer,
      ),
    ),
    
    // Updated FilledButton theme for Material 3
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    
    // Updated Chip theme for Material 3
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide.none,
      backgroundColor: _lightColorScheme.surfaceContainerHighest,
      selectedColor: _lightColorScheme.primaryContainer,
      labelStyle: TextStyle(color: _lightColorScheme.onSurfaceVariant),
    ),
    
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontWeight: FontWeight.w600),
      labelLarge: TextStyle(letterSpacing: 0.1),
    ),
    
    // Divider theme
    dividerTheme: DividerThemeData(
      color: _lightColorScheme.outlineVariant,
      thickness: 1,
      space: 32,
    ),
    
    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: _lightColorScheme.primary,
      thumbColor: _lightColorScheme.primary,
      overlayColor: _lightColorScheme.primary.withValues(alpha: 0.1),
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    colorScheme: _darkColorScheme,
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Updated AppBar theme for Material 3
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: _darkColorScheme.surface.withValues(alpha: 0.95),
      foregroundColor: _darkColorScheme.onSurface,
      scrolledUnderElevation: 0.5,
    ),
    
    scaffoldBackgroundColor: _darkColorScheme.surface,
    
    // Updated Card theme for Material 3
    cardTheme: CardTheme(
      color: _darkColorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Updated ListTileTheme for Material 3
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    
    // Updated Segmented Button theme
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return _darkColorScheme.primaryContainer;
          }
          return _darkColorScheme.surfaceContainerHighest;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return _darkColorScheme.onPrimaryContainer;
          }
          return _darkColorScheme.onSurfaceVariant;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    
    fontFamily: 'Poppins',
    
    // Updated Button theme for Material 3
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: _darkColorScheme.primaryContainer,
        foregroundColor: _darkColorScheme.onPrimaryContainer,
      ),
    ),
    
    // Updated FilledButton theme for Material 3
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    
    // Updated Chip theme for Material 3
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide.none,
      backgroundColor: _darkColorScheme.surfaceContainerHighest,
      selectedColor: _darkColorScheme.primaryContainer,
      labelStyle: TextStyle(color: _darkColorScheme.onSurfaceVariant),
    ),
    
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: _darkColorScheme.onSurface,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: _darkColorScheme.onSurface,
      ),
      labelLarge: TextStyle(
        letterSpacing: 0.1,
        color: _darkColorScheme.onSurface,
      ),
    ),
    
    // Divider theme
    dividerTheme: DividerThemeData(
      color: _darkColorScheme.outlineVariant,
      thickness: 1,
      space: 32,
    ),
    
    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: _darkColorScheme.primary,
      thumbColor: _darkColorScheme.primary,
      overlayColor: _darkColorScheme.primary.withValues(alpha: 0.1),
    ),
  );
}
