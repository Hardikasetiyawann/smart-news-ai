import '../entities/dashboard_news_entity.dart';
import '../entities/dashboard_category_entity.dart';
import '../entities/dashboard_publisher_entity.dart';
import '../entities/dashboard_user_entity.dart';

abstract class DashboardRepository {
  Future<DashboardUserEntity> getCurrentUser();

  Future<List<DashboardNewsEntity>> getLatestNews();
  Future<List<DashboardNewsEntity>> getTrendingNews();
  Future<List<DashboardNewsEntity>> getNewsByCategory(int categoryId);
  Future<List<DashboardNewsEntity>> getNewsByPublisher(int publisherId);

  Future<List<DashboardCategoryEntity>> getCategories();

  Future<List<DashboardPublisherEntity>> getPublishers();
}
