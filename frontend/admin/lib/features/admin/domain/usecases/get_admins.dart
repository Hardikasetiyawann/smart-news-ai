import '../entities/admin.dart';
import '../repositories/admin_repository.dart';

class GetAdmins {
  final AdminRepository repository;

  GetAdmins(this.repository);

  Future<List<Admin>> call() {
    return repository.getAll();
  }
}
