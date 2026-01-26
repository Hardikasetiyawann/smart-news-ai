import '../../domain/entities/admin.dart';

class AdminModel extends Admin {
  AdminModel({
    required super.id,
    required super.username,
    required super.email,
    required super.fullName,
    super.lastLogin,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['full_name'],
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
    );
  }
}
