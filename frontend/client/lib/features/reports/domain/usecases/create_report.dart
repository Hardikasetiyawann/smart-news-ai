import '../entities/report_entity.dart';
import '../repositories/report_repository.dart';

class CreateReport {
  final ReportRepository repository;

  CreateReport(this.repository);

  Future<void> execute(ReportEntity report) {
    return repository.createReport(report);
  }
}
