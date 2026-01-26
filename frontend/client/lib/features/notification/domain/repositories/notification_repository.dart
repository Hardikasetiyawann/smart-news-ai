import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications({
    int limit = 20,
    int offset = 0,
  });

  Future<void> markAsRead(int id);

  Future<void> deleteNotification(int id);
}
