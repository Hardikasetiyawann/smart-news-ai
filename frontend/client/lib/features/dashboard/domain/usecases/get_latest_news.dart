import '../entities/dashboard_news_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetLatestNews {
  final DashboardRepository repository;

  GetLatestNews(this.repository);

  Future<List<DashboardNewsEntity>> call() {
    return repository.getLatestNews();
  }
}
