import '../entities/liked_news_entity.dart';
import '../repositories/profile_repository.dart';

class GetLikedNewsUseCase {
  final ProfileRepository repository;

  GetLikedNewsUseCase(this.repository);

  Future<List<LikedNewsEntity>> call() {
    return repository.getLikedNews();
  }
}