import '../entities/admin.dart';

abstract class AdminRepository {
  Future<List<Admin>> getAll();

  Future<void> create({
    required String username,
    required String email,
    required String password,
    required String fullName,
  });

  /// 🔐 password OPSIONAL
  Future<void> update({
    required int id,
    required String username,
    required String email,
    required String fullName,
    String? password,
  });

  Future<void> delete(int id);
}
