import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeStorage {
  static const _key = 'theme_mode';

  static Future<void> saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  static Future<ThemeMode> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);

    if (value == ThemeMode.dark.name) {
      return ThemeMode.dark;
    }
    if (value == ThemeMode.light.name) {
      return ThemeMode.light;
    }

    return ThemeMode.system;
  }
}
