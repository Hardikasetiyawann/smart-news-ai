// domain/repositories/history_repository.dart
import '../entities/reading_history.dart';

abstract class HistoryRepository {
  Future<List<ReadingHistory>> getAllHistory();
  Future<void> deleteHistory(int newsId);
  Future<void> clearHistory();
  Future<void> recordRead(int newsId);
}
