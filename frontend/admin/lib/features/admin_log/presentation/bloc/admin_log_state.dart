import '../../domain/entities/admin_log.dart';

abstract class AdminLogState {}

class AdminLogInitial extends AdminLogState {}

class AdminLogLoading extends AdminLogState {}

class AdminLogLoaded extends AdminLogState {
  final List<AdminLog> logs;

  AdminLogLoaded(this.logs);
}

class AdminLogError extends AdminLogState {
  final String message;

  AdminLogError(this.message);
}
