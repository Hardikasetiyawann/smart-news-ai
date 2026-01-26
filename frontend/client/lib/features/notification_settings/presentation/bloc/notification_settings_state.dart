abstract class NotificationSettingsState {}

class NotificationSettingsInitial extends NotificationSettingsState {}

class NotificationSettingsLoading extends NotificationSettingsState {}

class NotificationSettingsLoaded extends NotificationSettingsState {
  final bool news;
  final bool silent;

  NotificationSettingsLoaded({
    required this.news,
    required this.silent,
  });
}

class NotificationSettingsError extends NotificationSettingsState {
  final String message;
  NotificationSettingsError(this.message);
}

