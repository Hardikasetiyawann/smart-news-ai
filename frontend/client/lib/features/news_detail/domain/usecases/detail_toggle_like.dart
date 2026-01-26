import '../entities/detail_interaction_entity.dart';
import '../repositories/detail_repository.dart';

class DetailToggleLike {
  final DetailRepository repository;

  DetailToggleLike(this.repository);

  Future<DetailInteractionEntity> like(int newsId) {
    return repository.likeNews(newsId);
  }

  Future<DetailInteractionEntity> unlike(int newsId) {
    return repository.unlikeNews(newsId);
  }
}
