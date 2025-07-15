import 'package:flutter/material.dart';

/// Centralized application theme.  
/// Use MyAppTheme.lightTheme or MyAppTheme.darkTheme in your MaterialApp.
class MyAppTheme {
  MyAppTheme._(); // private constructor to prevent instantiation

  // Design tokens: colors
  static const Color _primary = Color(0xFFA3DA8D);
  static const Color _onPrimary = Color(0xFFFFFFFF);
  static const Color _text = Color(0xFF101820);
  static const Color _bgLight = Color(0xFFF4F5FA);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _accent = Color(0xFFE5E6EE);
  static const Color _icon = Color(0xFF101820);

  // Radii
  static const BorderRadiusGeometry _cardRadius = BorderRadius.all(Radius.circular(12));
  static const BorderRadiusGeometry _buttonRadius = BorderRadius.all(Radius.circular(24));

  /// Light theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _primary,
    scaffoldBackgroundColor: _bgLight,
    colorScheme: ColorScheme.light(
      primary: _primary,
      onPrimary: _onPrimary,
      surface: _surface,
      onSurface: _text,
    ),

    // Typography: updated labels
    textTheme: TextTheme(
      displayLarge: TextStyle(fontFamily: 'Lato', fontSize: 32, fontWeight: FontWeight.bold, color: _text),
      displayMedium: TextStyle(fontFamily: 'Lato', fontSize: 28, fontWeight: FontWeight.bold, color: _text),
      displaySmall: TextStyle(fontFamily: 'Lato', fontSize: 24, fontWeight: FontWeight.bold, color: _text),
      headlineLarge: TextStyle(fontFamily: 'Lato', fontSize: 22, fontWeight: FontWeight.bold, color: _text),
      headlineMedium: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w600, color: _text),
      headlineSmall: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w600, color: _text),
      titleLarge: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.bold, color: _text),
      titleMedium: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w600, color: _text),
      titleSmall: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w600, color: _text),
      bodyLarge: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.normal, color: _text),
      bodyMedium: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.normal, color: _text),
      bodySmall: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.normal, color: _text),
      labelLarge: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.bold, color: _text),
      labelMedium: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w600, color: _text),
      labelSmall: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w600, color: _text),
    ),

    // Card styling
    cardTheme: CardTheme(
      color: _surface,
      shape: RoundedRectangleBorder(borderRadius: _cardRadius),
      elevation: 2,
      margin: EdgeInsets.zero,
    ),

    // ElevatedButton styling
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: _text,
        shape: RoundedRectangleBorder(borderRadius: _buttonRadius),
        padding: 	EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        textStyle: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.bold),
      ),
    ),

    // AppBar styling
    appBarTheme: AppBarTheme(
      backgroundColor: _primary,
      foregroundColor: _onPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.bold, color: _onPrimary),
      iconTheme: IconThemeData(color: _onPrimary),
    ),

    // Input (TextField) styling
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surface,
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(fontFamily: 'Lato', fontSize: 14, color: _text.withOpacity(0.5)),
    ),

    // Icon styling
    iconTheme: IconThemeData(
      color: _icon,
      size: 24,
    ),
  );

  /// Dark theme (optional customization)
  static final ThemeData darkTheme = lightTheme.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF121212),
    colorScheme: ColorScheme.dark(
      primary: _primary,
      onPrimary: _text,
      surface: Color(0xFF1E1E1E),
      onSurface: _text,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontFamily: 'Lato', fontSize: 32, fontWeight: FontWeight.bold, color: _onPrimary),
      displayMedium: TextStyle(fontFamily: 'Lato', fontSize: 28, fontWeight: FontWeight.bold, color: _onPrimary),
      displaySmall: TextStyle(fontFamily: 'Lato', fontSize: 24, fontWeight: FontWeight.bold, color: _onPrimary),
      headlineLarge: TextStyle(fontFamily: 'Lato', fontSize: 22, fontWeight: FontWeight.bold, color: _onPrimary),
      headlineMedium: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w600, color: _onPrimary),
      headlineSmall: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w600, color: _onPrimary),
      titleLarge: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.bold, color: _onPrimary),
      titleMedium: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w600, color: _onPrimary),
      titleSmall: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w600, color: _onPrimary),
      bodyLarge: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.normal, color: _onPrimary),
      bodyMedium: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.normal, color: _onPrimary),
      bodySmall: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.normal, color: _onPrimary),
      labelLarge: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.bold, color: _onPrimary),
      labelMedium: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w600, color: _onPrimary),
      labelSmall: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w600, color: _onPrimary),
    ),
  );
}