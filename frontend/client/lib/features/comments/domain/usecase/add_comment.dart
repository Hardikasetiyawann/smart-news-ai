import '../repositories/comment_repository.dart';

class AddComment {
  final CommentRepository repository;

  AddComment(this.repository);

  Future<void> execute({required int newsId, required String content}) {
    return repository.addComment(newsId: newsId, content: content);
  }
}
