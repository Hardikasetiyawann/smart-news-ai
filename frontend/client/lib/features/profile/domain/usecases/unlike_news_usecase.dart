import '../repositories/profile_repository.dart';

class UnlikeNewsUseCase {
  final ProfileRepository repository;

  UnlikeNewsUseCase(this.repository);

  Future<void> call(int newsId) {
    return repository.unlikeNews(newsId);
  }
}