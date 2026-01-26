import '../repositories/history_repository.dart';

class RecordReadHistory {
  final HistoryRepository repository;

  RecordReadHistory(this.repository);

  Future<void> call(int newsId) {
    return repository.recordRead(newsId);
  }
}

