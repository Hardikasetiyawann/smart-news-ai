import '../entities/dashboard_news_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetTrendingNews {
  final DashboardRepository repository;

  GetTrendingNews(this.repository);

  Future<List<DashboardNewsEntity>> call() {
    return repository.getTrendingNews();
  }
}
