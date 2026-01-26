import '../entities/admin_log.dart';
import '../repositories/admin_log_repository.dart';

class GetAdminLogs {
  final AdminLogRepository repository;

  GetAdminLogs(this.repository);

  Future<List<AdminLog>> call() {
    return repository.getLogs();
  }
}
