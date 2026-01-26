import '../repositories/notification_settings_repository.dart';
import '../entities/notification_settings_entity.dart';

class UpdateNotificationSettings {
  final NotificationSettingsRepository repository;

  UpdateNotificationSettings(this.repository);

  Future<void> call(NotificationSettingsEntity settings) {
    return repository.updateSettings(settings);
  }
}
