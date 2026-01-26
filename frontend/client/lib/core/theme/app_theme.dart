import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme:
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF5F8D7A),
          brightness: Brightness.light,
        ).copyWith(
          background: const Color(0xFFF4F6F5),
          surface: const Color(0xFFF9FAF9),
          onSurface: const Color(0xFF1F2D27),
        ),

    scaffoldBackgroundColor: const Color(0xFFF4F6F5),

    cardColor: const Color(0xFFF9FAF9),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Color(0xFF1F2D27),
    ),

    dividerColor: const Color(0xFFDDE3DF),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF1F2D27)),
      bodyMedium: TextStyle(color: Color(0xFF2E3E37)),
      bodySmall: TextStyle(color: Color(0xFF5E6F67)),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2D27),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF5F8D7A),
      brightness: Brightness.dark,
    ),

    scaffoldBackgroundColor: const Color(0xFF0F1311),
    cardColor: const Color(0xFF1A1F1C),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),

    dividerColor: Colors.grey.shade800,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE4ECE8)),
      bodyMedium: TextStyle(color: Color(0xFFCAD6D0)),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFFE4ECE8),
      ),
    ),
  );
}
