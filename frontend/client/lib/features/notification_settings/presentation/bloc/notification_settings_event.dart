abstract class NotificationSettingsEvent {}

class LoadNotificationSettings extends NotificationSettingsEvent {}

class UpdateNotificationSettingsEvent extends NotificationSettingsEvent {
  final bool? news;
  final bool? silent;

  UpdateNotificationSettingsEvent({
    this.news,
    this.silent,
  });
}
