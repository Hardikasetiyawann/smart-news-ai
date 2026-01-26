import 'package:dio/dio.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> fetchNotifications({int limit, int offset});

  Future<void> markAsRead(int id);

  Future<void> deleteNotification(int id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl(this.dio);

  // =====================
  // SAFE LIST EXTRACTOR
  // =====================
  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data['data'] is List) {
      return data['data'];
    }
    return [];
  }

  @override
  Future<List<NotificationModel>> fetchNotifications({
    int limit = 20,
    int offset = 0,
  }) async {
    final res = await dio.get(
      '/notifications',
      queryParameters: {'limit': limit, 'offset': offset},
    );

    final list = _extractList(res.data);

    return list.map((e) => NotificationModel.fromJson(e)).toList();
  }

  @override
  Future<void> markAsRead(int id) async {
    await dio.patch('/notifications/$id/read');
  }

  @override
  Future<void> deleteNotification(int id) async {
    await dio.delete('/notifications/$id');
  }
}
