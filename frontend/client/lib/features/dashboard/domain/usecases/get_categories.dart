import '../entities/dashboard_category_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetCategories {
  final DashboardRepository repository;

  GetCategories(this.repository);

  Future<List<DashboardCategoryEntity>> call() {
    return repository.getCategories();
  }
}
