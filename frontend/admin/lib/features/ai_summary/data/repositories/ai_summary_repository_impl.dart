import '../../domain/entities/ai_summary.dart';
import '../../domain/repositories/ai_summary_repository.dart';
import '../datasources/ai_summary_remote_datasource.dart';

class AiSummaryRepositoryImpl implements AiSummaryRepository {
  final AiSummaryRemoteDataSource remote;

  AiSummaryRepositoryImpl(this.remote);

  @override
  Future<List<AiSummary>> getAll() {
    return remote.getAllSummaries();
  }
}
