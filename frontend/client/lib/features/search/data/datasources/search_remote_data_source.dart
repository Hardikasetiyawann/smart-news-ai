import 'package:dio/dio.dart';
import '../models/search_news_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchNewsModel>> searchNews(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl(this.dio);

  @override
  Future<List<SearchNewsModel>> searchNews(String query) async {
    final response = await dio.get(
      '/news/search',
      queryParameters: {'q': query},
    );

    final List data = response.data as List;

    return data.map((e) => SearchNewsModel.fromJson(e)).toList();
  }

  Future<SearchNewsModel> getSearchNews(int newsId) async {
    try {
      final newsRes = await dio.get('/news/$newsId');
      final newsData = newsRes.data['data'] ?? newsRes.data;

      return SearchNewsModel.fromJson(newsData);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load news detail',
      );
    }
  }
}
