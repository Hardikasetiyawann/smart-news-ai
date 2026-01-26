import '../../domain/entities/detail_interaction_entity.dart';
import '../../domain/entities/detail_news_entity.dart';
import '../../domain/repositories/detail_repository.dart';
import '../datasources/detail_remote_datasource.dart';

class DetailRepositoryImpl implements DetailRepository {
  final DetailRemoteDataSource remoteDataSource;

  DetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DetailNewsEntity> getDetailNews(int newsId) {
    return remoteDataSource.getDetailNews(newsId);
  }

  @override
  Future<String> getDetailAiSummary(int newsId) {
    return remoteDataSource.getDetailAiSummary(newsId);
  }

  @override
  Future<DetailInteractionEntity> getDetailInteraction(int newsId) {
    return remoteDataSource.getDetailInteraction(newsId);
  }

  @override
  Future<DetailInteractionEntity> likeNews(int newsId) {
    return remoteDataSource.likeNews(newsId);
  }

  @override
  Future<DetailInteractionEntity> unlikeNews(int newsId) {
    return remoteDataSource.unlikeNews(newsId);
  }

  @override
  Future<void> recordNewsView(int newsId) async {
    await remoteDataSource.recordNewsView(newsId);
  }
}
