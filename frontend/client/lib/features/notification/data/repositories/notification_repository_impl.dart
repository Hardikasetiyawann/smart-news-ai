import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;

  NotificationRepositoryImpl(this.remote);

  @override
  Future<List<NotificationEntity>> getNotifications({
    int limit = 20,
    int offset = 0,
  }) async {
    final models = await remote.fetchNotifications(
      limit: limit,
      offset: offset,
    );

    return models
        .map(
          (m) => NotificationEntity(
            id: m.id,
            title: m.title,
            body: m.body,
            createdAt: m.createdAt,
            isRead: m.isRead,
            type: m.type,
            newsId: m.newsId,
          ),
        )
        .toList();
  }

  @override
  Future<void> markAsRead(int id) {
    return remote.markAsRead(id);
  }

  @override
  Future<void> deleteNotification(int id) {
    return remote.deleteNotification(id);
  }
}
