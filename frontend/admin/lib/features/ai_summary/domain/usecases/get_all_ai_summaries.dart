import '../entities/ai_summary.dart';
import '../repositories/ai_summary_repository.dart';

class GetAllAiSummaries {
  final AiSummaryRepository repository;

  GetAllAiSummaries(this.repository);

  Future<List<AiSummary>> call() {
    return repository.getAll();
  }
}
