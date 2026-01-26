import '../repositories/history_repository.dart';

class ClearHistory {
  final HistoryRepository repository;

  ClearHistory(this.repository);

  Future<void> call() {
    return repository.clearHistory();
  }
}
