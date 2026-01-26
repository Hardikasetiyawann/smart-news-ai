import '../entities/ai_summary.dart';

abstract class AiSummaryRepository {
  Future<List<AiSummary>> getAll();
}
