import '../repositories/detail_repository.dart';

class GetDetailAiSummary {
  final DetailRepository repository;

  GetDetailAiSummary(this.repository);

  Future<String> execute(int newsId) {
    return repository.getDetailAiSummary(newsId);
  }
}
