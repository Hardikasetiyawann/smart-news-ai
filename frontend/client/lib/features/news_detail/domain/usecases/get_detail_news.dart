import '../entities/detail_news_entity.dart';
import '../repositories/detail_repository.dart';

class GetDetailNews {
  final DetailRepository repository;

  GetDetailNews(this.repository);

  Future<DetailNewsEntity> execute(int newsId) {
    return repository.getDetailNews(newsId);
  }
}
