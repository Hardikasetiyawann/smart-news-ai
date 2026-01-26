import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../network/dio_client.dart';

typedef MessageHandler = void Function(RemoteMessage message);

class FirebaseNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init({
    required MessageHandler onForeground,
    required MessageHandler onTap,
  }) async {
    // 🔐 Permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔑 Initial token
    final token = await _messaging.getToken();
    if (token != null) {
      await _sendTokenToBackend(token);
    }

    // 🔄 Token refresh
    _messaging.onTokenRefresh.listen((token) async {
      debugPrint('🔁 FCM token refreshed');
      await _sendTokenToBackend(token);
    });

    // 📩 Foreground
    FirebaseMessaging.onMessage.listen(onForeground);

    // 📲 Open from background
    FirebaseMessaging.onMessageOpenedApp.listen(onTap);

    // 🚀 Open from terminated
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      onTap(initialMessage);
    }

    // 🌙 Background
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      await DioClient.dio.post(
        '/devices',
        data: {
          'fcm_token': token,
          'platform': _platform,
        },
      );
      debugPrint('✅ FCM token sent to backend');
    } catch (e) {
      debugPrint('❌ Failed to send FCM token: $e');
    }
  }

  String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  debugPrint('🌙 Background message: ${message.messageId}');
}
