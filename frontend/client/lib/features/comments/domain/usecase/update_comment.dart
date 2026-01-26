import '../repositories/comment_repository.dart';

class UpdateComment {
  final CommentRepository repository;

  UpdateComment(this.repository);

  Future<void> execute({required int commentId, required String content}) {
    return repository.updateComment(commentId: commentId, content: content);
  }
}
