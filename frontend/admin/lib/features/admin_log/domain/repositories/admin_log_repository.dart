import '../entities/admin_log.dart';

abstract class AdminLogRepository {
  Future<List<AdminLog>> getLogs();
}
