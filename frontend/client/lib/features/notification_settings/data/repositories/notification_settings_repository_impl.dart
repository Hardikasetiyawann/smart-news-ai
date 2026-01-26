import '../../domain/entities/notification_settings_entity.dart';
import '../../domain/repositories/notification_settings_repository.dart';
import '../datasources/notification_settings_remote_datasource.dart';
import '../models/notification_settings_model.dart';

class NotificationSettingsRepositoryImpl
    implements NotificationSettingsRepository {
  final NotificationSettingsRemoteDataSource remote;

  NotificationSettingsRepositoryImpl(this.remote);

  @override
  Future<NotificationSettingsEntity> getSettings() async {
    final model = await remote.fetchSettings();

    return NotificationSettingsEntity(
      news: model.news,
      silent: model.silent,
    );
  }

  @override
  Future<void> updateSettings(NotificationSettingsEntity settings) {
    return remote.updateSettings(
      NotificationSettingsModel(
        news: settings.news,
        silent: settings.silent,
      ),
    );
  }
}
