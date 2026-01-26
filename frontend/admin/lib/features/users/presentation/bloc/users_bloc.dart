import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/toggle_user_status.dart';
import 'users_event.dart';
import 'users_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  final ToggleUserStatus toggleUserStatus;

  UserBloc({required this.getUsers, required this.toggleUserStatus})
    : super(UserInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<ToggleUserStatusEvent>(_onToggleStatus);
  }

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final users = await getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onToggleStatus(
    ToggleUserStatusEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await toggleUserStatus(event.userId);
      emit(UserActionSuccess('Status user berhasil diubah'));
      add(const LoadUsersEvent());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
