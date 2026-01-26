import '../repositories/report_repository.dart';

class DeleteReport {
  final ReportRepository repo;
  DeleteReport(this.repo);

  Future<void> call(int id) => repo.deleteReport(id);
}
