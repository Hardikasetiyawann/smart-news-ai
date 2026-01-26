import '../repositories/news_repository.dart';

class DeleteNews {
  final NewsRepository repository;

  DeleteNews(this.repository);

  Future<void> call(int id) async {
    await repository.deleteNews(id);
  }
}
