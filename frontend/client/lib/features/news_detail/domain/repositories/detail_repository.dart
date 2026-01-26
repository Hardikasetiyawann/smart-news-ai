import '../entities/detail_news_entity.dart';
import '../entities/detail_interaction_entity.dart';

abstract class DetailRepository {
  Future<DetailNewsEntity> getDetailNews(int newsId);

  Future<String> getDetailAiSummary(int newsId);

  Future<DetailInteractionEntity> getDetailInteraction(int newsId);

  Future<DetailInteractionEntity> likeNews(int newsId);
  Future<DetailInteractionEntity> unlikeNews(int newsId);

  Future<void> recordNewsView(int newsId);
}
