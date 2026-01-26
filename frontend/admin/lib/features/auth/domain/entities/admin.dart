import 'package:equatable/equatable.dart';

class Admin extends Equatable {
  final int id;
  final String username;
  final String fullName;
  final String token;

  const Admin({
    required this.id,
    required this.username,
    required this.fullName,
    required this.token,
  });

  @override
  List<Object?> get props => [id, username, fullName, token];
}
