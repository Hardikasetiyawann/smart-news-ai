import '../entities/detail_interaction_entity.dart';
import '../repositories/detail_repository.dart';

class GetDetailInteraction {
  final DetailRepository repository;

  GetDetailInteraction(this.repository);

  Future<DetailInteractionEntity> execute(int newsId) {
    return repository.getDetailInteraction(newsId);
  }

  Future<DetailInteractionEntity> like(int newsId) {
    return repository.likeNews(newsId);
  }

  Future<DetailInteractionEntity> unlike(int newsId) {
    return repository.unlikeNews(newsId);
  }
}
