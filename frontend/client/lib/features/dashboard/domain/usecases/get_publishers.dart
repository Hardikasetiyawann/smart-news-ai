import '../entities/dashboard_publisher_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetPublishers {
  final DashboardRepository repository;

  GetPublishers(this.repository);

  Future<List<DashboardPublisherEntity>> call() {
    return repository.getPublishers();
  }
}
