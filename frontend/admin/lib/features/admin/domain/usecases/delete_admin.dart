import '../repositories/admin_repository.dart';

class DeleteAdmin {
  final AdminRepository repository;

  DeleteAdmin(this.repository);

  Future<void> call(int id) {
    return repository.delete(id);
  }
}
