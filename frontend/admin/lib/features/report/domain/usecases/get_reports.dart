import '../entities/report.dart';
import '../repositories/report_repository.dart';

class GetReports {
  final ReportRepository repo;
  GetReports(this.repo);

  Future<List<Report>> call() => repo.getReports();
}
