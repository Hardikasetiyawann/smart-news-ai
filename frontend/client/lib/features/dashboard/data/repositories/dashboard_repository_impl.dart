import '../../domain/entities/dashboard_news_entity.dart';
import '../../domain/entities/dashboard_category_entity.dart';
import '../../domain/entities/dashboard_publisher_entity.dart';
import '../../domain/entities/dashboard_user_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource datasource;

  DashboardRepositoryImpl(this.datasource);

  // get current user
  @override
  Future<DashboardUserEntity> getCurrentUser() async {
    final model = await datasource.getCurrentUser();
    return model; // ✔️ model extends entity → aman
  }

  // get latest news
  @override
  Future<List<DashboardNewsEntity>> getLatestNews() async {
    final models = await datasource.getLatestNews();
    return models;
  }

  // get trending news
  @override
  Future<List<DashboardNewsEntity>> getTrendingNews() async {
    final models = await datasource.getTrendingNews();
    return models;
  }

  // get news by category
  @override
  Future<List<DashboardNewsEntity>> getNewsByCategory(int categoryId) async {
    final models = await datasource.getNewsByCategory(categoryId);
    return models;
  }

  // get news by publisher
  @override
  Future<List<DashboardNewsEntity>> getNewsByPublisher(int publisherId) async {
    final models = await datasource.getNewsByPublisher(publisherId);
    return models;
  }

  // get categories
  @override
  Future<List<DashboardCategoryEntity>> getCategories() async {
    final models = await datasource.getCategories();
    return models;
  }

  // get publishers
  @override
  Future<List<DashboardPublisherEntity>> getPublishers() async {
    final models = await datasource.getPublishers();
    return models;
  }
}
