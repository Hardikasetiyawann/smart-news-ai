import '../repositories/admin_repository.dart';

class UpdateAdmin {
  final AdminRepository repository;

  UpdateAdmin(this.repository);

  Future<void> call({
    required int id,
    required String username,
    required String email,
    required String fullName,
    String? password, // 👈 TAMBAHAN (opsional)
  }) {
    return repository.update(
      id: id,
      username: username,
      email: email,
      fullName: fullName,
      password: password, // 👈 TERUSKAN
    );
  }
}
