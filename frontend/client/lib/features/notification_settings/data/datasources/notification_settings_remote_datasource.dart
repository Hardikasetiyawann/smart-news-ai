import 'package:dio/dio.dart';
import '../models/notification_settings_model.dart';

class NotificationSettingsRemoteDataSource {
  final Dio dio;

  NotificationSettingsRemoteDataSource(this.dio);

  Future<NotificationSettingsModel> fetchSettings() async {
    final res = await dio.get('/notification-settings');

    final data = res.data['data']; // 🔥 AMBIL data

    return NotificationSettingsModel.fromJson(data);
  }

  Future<void> updateSettings(NotificationSettingsModel model) async {
    await dio.put('/notification-settings', data: model.toJson());
  }
}
