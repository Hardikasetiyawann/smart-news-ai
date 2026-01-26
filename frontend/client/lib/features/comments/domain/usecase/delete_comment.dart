import '../repositories/comment_repository.dart';

class DeleteComment {
  final CommentRepository repository;

  DeleteComment(this.repository);

  Future<void> execute(int commentId) {
    return repository.deleteComment(commentId);
  }
}
