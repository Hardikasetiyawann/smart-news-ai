import '../../domain/entities/user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  UserLoaded(this.users);
}

class UserActionSuccess extends UserState {
  final String message;
  UserActionSuccess(this.message);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
