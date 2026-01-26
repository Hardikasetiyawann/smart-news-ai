import '../repositories/report_repository.dart';

class UpdateReportStatus {
  final ReportRepository repo;
  UpdateReportStatus(this.repo);

  Future<void> call(int id, String status) => repo.updateStatus(id, status);
}
