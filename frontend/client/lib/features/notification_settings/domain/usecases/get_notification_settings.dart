import '../repositories/notification_settings_repository.dart';
import '../entities/notification_settings_entity.dart';

class GetNotificationSettings {
  final NotificationSettingsRepository repository;

  GetNotificationSettings(this.repository);

  Future<NotificationSettingsEntity> call() {
    return repository.getSettings();
  }
}
