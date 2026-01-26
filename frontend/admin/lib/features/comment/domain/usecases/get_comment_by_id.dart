import '../entities/comment.dart';
import '../repositories/comment_repository.dart';

class GetCommentById {
  final CommentRepository repo;
  GetCommentById(this.repo);

  Future<Comment> call(int id) {
    return repo.getById(id);
  }
}
