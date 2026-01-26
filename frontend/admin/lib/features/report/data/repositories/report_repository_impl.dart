import '../../domain/entities/report.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remote;
  ReportRepositoryImpl(this.remote);

  @override
  Future<List<Report>> getReports() => remote.getAll();

  @override
  Future<void> updateStatus(int id, String status) =>
      remote.updateStatus(id, status);

  @override
  Future<void> deleteReport(int id) => remote.delete(id);
}
