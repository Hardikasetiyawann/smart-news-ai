import '../../domain/entities/comment.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_datasource.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remote;
  CommentRepositoryImpl(this.remote);

  @override
  Future<List<Comment>> getByNews(int newsId) {
    return remote.getByNews(newsId);
  }

  @override
  Future<Comment> getById(int id) {
    return remote.getById(id);
  }

  @override
  Future<void> delete(int id) {
    return remote.delete(id);
  }
}
