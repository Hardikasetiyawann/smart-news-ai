import '../entities/notification_settings_entity.dart';

abstract class NotificationSettingsRepository {
  Future<NotificationSettingsEntity> getSettings();
  Future<void> updateSettings(NotificationSettingsEntity settings);
}
