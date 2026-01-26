import '../entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getAll();
  Future<void> toggleStatus(int userId);
}
