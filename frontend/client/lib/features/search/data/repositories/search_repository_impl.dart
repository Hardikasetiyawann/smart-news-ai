import '../../domain/entities/search_news.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SearchNews>> searchNews(String query) async {
    return await remoteDataSource.searchNews(query);
  }
}
