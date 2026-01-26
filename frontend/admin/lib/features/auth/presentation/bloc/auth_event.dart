import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginPressed extends AuthEvent {
  final String username;
  final String password;

  // ✅ PERBAIKAN: Gunakan kurung kurawal {} agar jadi Named Parameter
  const LoginPressed({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}
