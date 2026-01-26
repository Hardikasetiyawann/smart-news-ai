import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;

  UserRepositoryImpl(this.remote);

  @override
  Future<List<User>> getAll() {
    return remote.getAll();
  }

  @override
  Future<void> toggleStatus(int userId) {
    return remote.toggleStatus(userId);
  }
}
