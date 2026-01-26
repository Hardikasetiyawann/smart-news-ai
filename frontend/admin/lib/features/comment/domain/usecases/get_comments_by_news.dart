import '../entities/comment.dart';
import '../repositories/comment_repository.dart';

class GetCommentsByNews {
  final CommentRepository repo;
  GetCommentsByNews(this.repo);

  Future<List<Comment>> call(int newsId) {
    return repo.getByNews(newsId);
  }
}
