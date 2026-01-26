import '../entities/dashboard_user_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetCurrentUser {
  final DashboardRepository repository;

  GetCurrentUser(this.repository);

  Future<DashboardUserEntity> execute() {
    return repository.getCurrentUser();
  }
}
