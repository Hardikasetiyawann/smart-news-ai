import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/admin.dart';
import '../repositories/auth_repository.dart';

class LoginAdmin {
  final AuthRepository repository;

  LoginAdmin(this.repository);

  Future<Either<Failure, Admin>> call(String username, String password) async {
    return await repository.login(username, password);
  }
}
