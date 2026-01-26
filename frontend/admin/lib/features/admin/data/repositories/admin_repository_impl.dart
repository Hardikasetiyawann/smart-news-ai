import '../../domain/entities/admin.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remote;
  AdminRepositoryImpl(this.remote);

  @override
  Future<List<Admin>> getAll() => remote.getAll();

  @override
  Future<void> create({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) {
    return remote.create(
      username: username,
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  @override
  Future<void> update({
    required int id,
    required String username,
    required String email,
    required String fullName,
    String? password, // 👈 TAMBAHAN
  }) {
    return remote.update(
      id: id,
      username: username,
      email: email,
      fullName: fullName,
      password: password, // 👈 TERUSKAN KE REMOTE
    );
  }

  @override
  Future<void> delete(int id) => remote.delete(id);
}
