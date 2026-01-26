import '../repositories/history_repository.dart';

class DeleteHistory {
  final HistoryRepository repository;

  DeleteHistory(this.repository);

  Future<void> call(int newsId) {
    return repository.deleteHistory(newsId);
  }
}
