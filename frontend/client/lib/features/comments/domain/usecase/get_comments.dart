import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class GetComments {
  final CommentRepository repository;

  GetComments(this.repository);

  Future<List<CommentEntity>> execute(int newsId) {
    return repository.getComments(newsId);
  }
}
