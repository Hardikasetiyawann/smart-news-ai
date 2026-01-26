import '../entities/dashboard_news_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetNewsByCategory {
  final DashboardRepository repository;

  GetNewsByCategory(this.repository);

  Future<List<DashboardNewsEntity>> call(int categoryId) {
    return repository.getNewsByCategory(categoryId);
  }
}
