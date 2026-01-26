import 'package:client/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AuthService authService;

  SettingsBloc(this.authService) : super(SettingsInitial()) {
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());

    try {
      await authService.logout();
      emit(SettingsLoggedOut());
    } catch (e) {
      emit(SettingsError('Gagal logout, coba lagi'));
    }
  }
}
