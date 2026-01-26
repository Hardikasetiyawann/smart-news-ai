import '../entities/report_entity.dart';

abstract class ReportRepository {
  Future<void> createReport(ReportEntity report);
}
