import '../entities/news.dart';
import '../repositories/news_repository.dart';

class GetNewsById {
  final NewsRepository repository;

  GetNewsById(this.repository);

  Future<News> call(int id) {
    return repository.getById(id);
  }
}
