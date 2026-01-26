import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Error dari server (500, response error)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Error koneksi internet / timeout
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Koneksi internet bermasalah']);
}

/// Error autentikasi (username / password salah)
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Autentikasi gagal']);
}
