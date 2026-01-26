import '../entities/search_news.dart';
import '../repositories/search_repository.dart';

class SearchNewsUseCase {
  final SearchRepository repository;

  SearchNewsUseCase(this.repository);

  Future<List<SearchNews>> execute(String query) async {
    if (query.isEmpty) return [];

    return repository.searchNews(query);
  }
}
