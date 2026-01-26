import '../repositories/admin_repository.dart';

class CreateAdmin {
  final AdminRepository repository;

  CreateAdmin(this.repository);

  Future<void> call({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) {
    return repository.create(
      username: username,
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}
