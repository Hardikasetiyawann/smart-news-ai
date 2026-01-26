// domain/usecases/get_reading_history.dart
import '../entities/reading_history.dart';
import '../repositories/history_repository.dart';

class GetReadingHistory {
  final HistoryRepository repository;

  GetReadingHistory(this.repository);

  Future<List<ReadingHistory>> call() {
    return repository.getAllHistory();
  }
}
