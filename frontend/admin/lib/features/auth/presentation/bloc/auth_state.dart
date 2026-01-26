import 'package:equatable/equatable.dart';
import '../../domain/entities/admin.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final Admin admin;
  const AuthSuccess(this.admin);
  @override
  List<Object> get props => [admin];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object> get props => [message];
}
