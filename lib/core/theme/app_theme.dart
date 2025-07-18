// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryGreen = Color(0xFF28A745);
  static const Color accentGreen = Color(0xFF208538);
  static const Color lightBackground = Color(0xFFF9F9F9);
  static const Color darkText = Color(0xFF1C1C1E);
  static const Color secondaryText = Color(0xFF8A8A8E);
  static const Color dividerColor = Color(0xFFE5E5EA);
  static const Color errorColor = Color(0xFFDC3545);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color successColor = Color(0xFF28A745);
  static const Color infoColor = Color(0xFF17A2B8);

  // Text Styles
  static TextTheme get textTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();
    return baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize: 32, 
        fontWeight: FontWeight.bold, 
        color: darkText, 
        letterSpacing: -0.5
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 24, 
        fontWeight: FontWeight.w600, 
        color: darkText
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 20, 
        fontWeight: FontWeight.w600, 
        color: darkText
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 17, 
        fontWeight: FontWeight.w600, 
        color: darkText
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 16, 
        color: darkText, 
        height: 1.5
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14, 
        color: darkText.withOpacity(0.85), 
        height: 1.4
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 12, 
        color: secondaryText, 
        height: 1.3
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 16, 
        fontWeight: FontWeight.w600, 
        color: primaryGreen
      ),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: textTheme.bodyLarge?.fontFamily,
      
      // Page Transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryGreen),
        actionsIconTheme: const IconThemeData(color: primaryGreen),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: darkText,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightBackground,
        selectedItemColor: primaryGreen,
        unselectedItemColor: secondaryText,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600, 
          fontSize: 10
        ),
        unselectedLabelStyle: textTheme.bodySmall?.copyWith(fontSize: 10),
      ),
      
      // Card Theme
      cardTheme: const CardTheme(
        elevation: 2.0,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))
        ),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: primaryGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: secondaryText.withOpacity(0.8)
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: secondaryText),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          textStyle: textTheme.labelLarge?.copyWith(
            fontSize: 17, 
            fontWeight: FontWeight.w500, 
            color: Colors.white
          ),
          elevation: 2,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500, 
            fontSize: 16
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        )
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))
        ),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 0.5,
        space: 0.5,
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        iconColor: secondaryText,
        tileColor: Colors.white,
        dense: false,
        horizontalTitleGap: 12.0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: secondaryText,
        size: 24,
      ),
      
      // Text Theme
      textTheme: textTheme,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
        background: Colors.white,
        surface: Colors.white,
        onSurface: darkText,
        error: errorColor,
      ),
      
      // Cupertino Override Theme
      cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: primaryGreen,
      ),
    );
  }

  // Dark Theme (para futuras implementações)
  static ThemeData get darkTheme {
    // Implementar tema escuro se necessário
    return lightTheme; // Por enquanto, usar o tema claro
  }
}