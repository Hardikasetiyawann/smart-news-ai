// data/repositories/history_repository_impl.dart
import '../../domain/entities/reading_history.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remote;

  HistoryRepositoryImpl(this.remote);

  @override
  Future<List<ReadingHistory>> getAllHistory() {
    return remote.getAllHistory();
  }

  @override
  Future<void> deleteHistory(int newsId) {
    return remote.deleteHistory(newsId);
  }

  @override
  Future<void> clearHistory() {
    return remote.clearHistory();
  }

  @override
  Future<void> recordRead(int newsId) {
    return remote.recordRead(newsId);
  }
}
