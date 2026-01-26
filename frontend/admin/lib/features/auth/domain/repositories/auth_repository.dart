import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/admin.dart';

abstract class AuthRepository {
  Future<Either<Failure, Admin>> login(String username, String password);
}
