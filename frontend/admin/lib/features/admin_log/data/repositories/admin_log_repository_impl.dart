import '../../domain/entities/admin_log.dart';
import '../../domain/repositories/admin_log_repository.dart';
import '../datasources/admin_log_remote_datasource.dart';

class AdminLogRepositoryImpl implements AdminLogRepository {
  final AdminLogRemoteDataSource remote;

  AdminLogRepositoryImpl(this.remote);

  @override
  Future<List<AdminLog>> getLogs() async {
    final models = await remote.getLogs();
    return models.map<AdminLog>((m) => m).toList();
  }
}
