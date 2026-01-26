import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<List<NotificationEntity>> call({
    int limit = 20,
    int offset = 0,
  }) {
    return repository.getNotifications(
      limit: limit,
      offset: offset,
    );
  }
}
