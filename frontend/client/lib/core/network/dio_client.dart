import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/jwt_storage.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: _getBaseUrl(),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final isLogin =
              options.uri.path.contains('auth-user/login');

          // 🔑 JIKA SUDAH ADA AUTH HEADER (FIREBASE TOKEN), JANGAN DIAPA-APAIN
          if (options.headers.containsKey('Authorization')) {
            if (kDebugMode) {
              debugPrint('🔐 Authorization already set (Firebase token)');
            }
            handler.next(options);
            return;
          }

          // 🔐 REQUEST PROTECTED → PAKAI JWT BACKEND
          if (!isLogin) {
            final jwt = await JwtStorage.getToken();
            if (jwt != null) {
              options.headers['Authorization'] = 'Bearer $jwt';
            }
          }

          if (kDebugMode) {
            debugPrint('➡️ ${options.method} ${options.uri}');
            debugPrint('➡️ HEADERS: ${options.headers}');
          }

          handler.next(options);
        },
        onError: (e, handler) {
          if (kDebugMode) {
            debugPrint('❌ DIO ERROR');
            debugPrint(e.message);
            debugPrint(e.response?.data.toString());
          }
          handler.next(e);
        },
      ),
    );

  static void clearAuth() {
    dio.options.headers.remove('Authorization');
  }

  static String _getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    if (Platform.isAndroid) {
      return 'https://5b47338c6e25.ngrok-free.app/api';
    }
    //     if (Platform.isAndroid) {
    //   return 'http://10.0.2.2:3000/api';
    // }
    return 'http://localhost:3000/api';
  }
}
