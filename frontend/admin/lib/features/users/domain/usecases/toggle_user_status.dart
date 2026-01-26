import '../repositories/user_repository.dart';

class ToggleUserStatus {
  final UserRepository repository;

  ToggleUserStatus(this.repository);

  Future<void> call(int userId) {
    return repository.toggleStatus(userId);
  }
}
