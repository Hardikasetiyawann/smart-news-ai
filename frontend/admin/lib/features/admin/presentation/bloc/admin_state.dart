import '../../domain/entities/admin.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<Admin> admins;
  AdminLoaded(this.admins);
}

class AdminSuccess extends AdminState {
  final String message;
  AdminSuccess(this.message);
}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}
