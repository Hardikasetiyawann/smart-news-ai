import '../entities/search_news.dart';

abstract class SearchRepository {
  Future<List<SearchNews>> searchNews(String query);
}
