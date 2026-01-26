import '../entities/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getByNews(int newsId);
  Future<Comment> getById(int id);
  Future<void> delete(int id);
}
