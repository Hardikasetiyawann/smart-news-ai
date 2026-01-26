import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_admin.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginAdmin loginAdmin;

  AuthBloc({required this.loginAdmin}) : super(AuthInitial()) {
    on<LoginPressed>((event, emit) async {
      if (state is AuthLoading) return;

      emit(AuthLoading());

      final result = await loginAdmin(event.username, event.password);

      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (admin) => emit(AuthSuccess(admin)),
      );
    });
  }
}
