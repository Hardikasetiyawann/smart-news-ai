import 'package:dio/dio.dart';

import '../models/detail_news_model.dart';
import '../models/detail_interaction_model.dart';
import '../../../../core/network/dio_client.dart';

class DetailRemoteDataSource {
  final Dio dio;

  DetailRemoteDataSource({Dio? dio}) : dio = dio ?? DioClient.dio;

  // detail news by newsId, kategoriId, dan publisherId
  Future<DetailNewsModel> getDetailNews(int newsId) async {
    try {
      final newsRes = await dio.get('/news/$newsId');
      final newsData = newsRes.data['data'] ?? newsRes.data;

      final categoryRes = await dio.get(
        '/categories/${newsData['category_id']}',
      );
      final categoryData = categoryRes.data['data'] ?? categoryRes.data;

      final publisherRes = await dio.get(
        '/publishers/${newsData['publisher_id']}',
      );
      final publisherData = publisherRes.data['data'] ?? publisherRes.data;

      return DetailNewsModel.fromJson(
        newsJson: newsData,
        categoryJson: categoryData,
        publisherJson: publisherData,
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load news detail',
      );
    }
  }

  // get ai summary
  Future<String> getDetailAiSummary(int newsId) async {
    try {
      final res = await dio.get('/ai-summary/$newsId');
      return res.data['summary_text'] ?? '';
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load AI summary',
      );
    }
  }

  // get interaction (like, view, comment)
  Future<DetailInteractionModel> getDetailInteraction(int newsId) async {
    try {
      final res = await dio.get('/news/$newsId/interactions');
      final data = res.data['data'] ?? res.data;
      return DetailInteractionModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load interaction',
      );
    }
  }

  // like news
  Future<DetailInteractionModel> likeNews(int newsId) async {
    try {
      await dio.post('/likes/$newsId');
      return getDetailInteraction(newsId);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to like news');
    }
  }

  // unlike news
  Future<DetailInteractionModel> unlikeNews(int newsId) async {
    try {
      await dio.delete('/likes/$newsId');

      return getDetailInteraction(newsId);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to unlike news');
    }
  }

  Future<void> recordNewsView(int newsId) async {
    await dio.post('/history', data: {'news_id': newsId});
    await dio.post('/news/$newsId/view');
  }
}
