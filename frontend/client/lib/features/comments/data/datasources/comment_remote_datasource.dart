import 'package:dio/dio.dart';
import '../models/comment_model.dart';
import '../models/comment_user_model.dart';
import '../../../../core/network/dio_client.dart';

class CommentRemoteDataSource {
  final Dio dio;

  CommentRemoteDataSource({Dio? dio}) : dio = dio ?? DioClient.dio;

  // get comments by news ID
  Future<List<CommentModel>> getComments(int newsId) async {
    try {
      final res = await dio.get('/comments/news/$newsId');

      final raw = res.data;
      List list;

      if (raw is List) {
        list = raw;
      } else if (raw is Map && raw['data'] is List) {
        list = raw['data'];
      } else if (raw is Map &&
          raw['data'] is Map &&
          raw['data']['comments'] is List) {
        list = raw['data']['comments'];
      } else {
        list = [];
      }

      return list.map<CommentModel>((e) => CommentModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load comments');
    }
  }

  // get users by list of IDs
  Future<Map<int, CommentUserModel>> getUsersByIds(List<int> userIds) async {
    if (userIds.isEmpty) return {};

    try {
      final res = await dio.get(
        '/users',
        queryParameters: {'ids': userIds.join(',')},
      );

      final raw = res.data;
      final List list = raw is Map && raw['data'] is List ? raw['data'] : raw;

      return {for (final u in list) u['id']: CommentUserModel.fromJson(u)};
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load users');
    }
  }

  // create comment
  Future<void> addComment({
    required int newsId,
    required String content,
  }) async {
    try {
      await dio.post(
        '/comments',
        data: {'news_id': newsId, 'content': content},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to add comment');
    }
  }

  // update comment
  Future<void> updateComment({
    required int commentId,
    required String content,
  }) async {
    try {
      await dio.put('/comments/$commentId', data: {'content': content});
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to update comment',
      );
    }
  }

  // delete comment
  Future<void> deleteComment(int commentId) async {
    try {
      await dio.delete('/comments/$commentId');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to delete comment',
      );
    }
  }
}
