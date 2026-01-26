import 'package:shared_preferences/shared_preferences.dart';

class JwtStorage {
  static const _jwtKey = 'jwt_token';

  /// Simpan JWT
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jwtKey, token);
  }

  /// Ambil JWT
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_jwtKey);
  }

  /// ✅ CEK JWT ADA / TIDAK
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Hapus JWT
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jwtKey);
  }
}
