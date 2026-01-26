import '../../domain/entities/admin.dart';

class AdminModel extends Admin {
  const AdminModel({
    required super.id,
    required super.username,
    required super.fullName,
    required super.token,
  });

  // Parsing dari respon JSON Backend
  factory AdminModel.fromJson(Map<String, dynamic> json, String token) {
    return AdminModel(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      token: token,
    );
  }
}
