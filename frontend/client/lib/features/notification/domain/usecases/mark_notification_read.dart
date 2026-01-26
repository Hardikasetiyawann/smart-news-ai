import '../repositories/notification_repository.dart';

class MarkNotificationRead {
  final NotificationRepository repository;

  MarkNotificationRead(this.repository);

  Future<void> call(int id) {
    return repository.markAsRead(id);
  }
}
