import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notification_settings.dart';
import '../../domain/usecases/update_notification_settings.dart';
import '../../domain/entities/notification_settings_entity.dart';
import 'notification_settings_event.dart';
import 'notification_settings_state.dart';

class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  final GetNotificationSettings getSettings;
  final UpdateNotificationSettings updateSettings;

  NotificationSettingsBloc({
    required this.getSettings,
    required this.updateSettings,
  }) : super(NotificationSettingsInitial()) {
    on<LoadNotificationSettings>(_onLoad);
    on<UpdateNotificationSettingsEvent>(_onUpdate);
  }

  Future<void> _onLoad(
    LoadNotificationSettings event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    try {
      emit(NotificationSettingsLoading());

      final data = await getSettings();

      emit(
        NotificationSettingsLoaded(
          news: data.news,
          silent: data.silent,
        ),
      );
    } catch (e) {
      emit(NotificationSettingsError('Gagal memuat pengaturan'));
    }
  }

  Future<void> _onUpdate(
    UpdateNotificationSettingsEvent event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    if (state is! NotificationSettingsLoaded) return;

    final current = state as NotificationSettingsLoaded;

    final updated = NotificationSettingsEntity(
      news: event.news ?? current.news,
      silent: event.silent ?? current.silent,
    );

    await updateSettings(updated);

    emit(
      NotificationSettingsLoaded(
        news: updated.news,
        silent: updated.silent,
      ),
    );
  }
}
