import '../entities/report.dart';

abstract class ReportRepository {
  Future<List<Report>> getReports();
  Future<void> updateStatus(int id, String status);
  Future<void> deleteReport(int id);
}
