import '../entities/comment_entity.dart';

abstract class CommentRepository {
  Future<List<CommentEntity>> getComments(int newsId);

  Future<void> addComment({required int newsId, required String content});

  Future<void> updateComment({required int commentId, required String content});

  Future<void> deleteComment(int commentId);
}
