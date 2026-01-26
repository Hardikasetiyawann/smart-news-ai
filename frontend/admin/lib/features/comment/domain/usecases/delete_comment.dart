import '../repositories/comment_repository.dart';

class DeleteComment {
  final CommentRepository repo;
  DeleteComment(this.repo);

  Future<void> call(int id) {
    return repo.delete(id);
  }
}
