import '../repositories/notification_repository.dart';

class DeleteNotification {
  final NotificationRepository repository;

  DeleteNotification(this.repository);

  Future<void> call(int id) {
    return repository.deleteNotification(id);
  }
}
