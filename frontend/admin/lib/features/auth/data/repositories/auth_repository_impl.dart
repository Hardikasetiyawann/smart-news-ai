import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/admin.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Admin>> login(String username, String password) async {
    try {
      final admin = await remoteDataSource.login(username, password);
      return Right(admin);
    } on Exception catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');

      if (message.toLowerCase().contains('password') ||
          message.toLowerCase().contains('login')) {
        return Left(AuthFailure(message));
      }

      if (message.toLowerCase().contains('koneksi') ||
          message.toLowerCase().contains('internet')) {
        return Left(NetworkFailure(message));
      }

      return Left(ServerFailure(message));
    }
  }
}
