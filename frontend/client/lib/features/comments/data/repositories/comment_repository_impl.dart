import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_datasource.dart';

// implementasi repository komentar
class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CommentEntity>> getComments(int newsId) {
    return remoteDataSource.getComments(newsId);
  }

  @override
  Future<void> addComment({required int newsId, required String content}) {
    return remoteDataSource.addComment(newsId: newsId, content: content);
  }

  @override
  Future<void> updateComment({
    required int commentId,
    required String content,
  }) {
    return remoteDataSource.updateComment(
      commentId: commentId,
      content: content,
    );
  }

  @override
  Future<void> deleteComment(int commentId) {
    return remoteDataSource.deleteComment(commentId);
  }
}
