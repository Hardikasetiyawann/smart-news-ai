import '../repositories/detail_repository.dart';

class RecordNewsView {
  final DetailRepository repository;

  RecordNewsView(this.repository);

  Future<void> execute(int newsId) async {
    return repository.recordNewsView(newsId);
  }
}
