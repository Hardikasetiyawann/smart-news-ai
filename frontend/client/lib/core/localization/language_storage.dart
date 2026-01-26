import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LanguageStorage {
  static const _key = 'language_code';

  static Future<void> saveLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }

  static Future<Locale?> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);

    if (code == null) return null; 
    return Locale(code);
  }
}

