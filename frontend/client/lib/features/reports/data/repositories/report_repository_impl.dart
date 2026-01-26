import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';
import '../models/report_model.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createReport(ReportEntity report) {
    final model = ReportModel(
      type: report.type,
      commentId: report.commentId,
      newsId: report.newsId,
      content: report.content,
    );

    return remoteDataSource.createReport(model);
  }
}
