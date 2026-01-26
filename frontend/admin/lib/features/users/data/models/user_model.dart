import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    super.fullName,
    super.email,
    super.imageUrl,
    super.authProvider,
    required super.isActive,
    super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      imageUrl: json['image_url'],
      authProvider: json['auth_provider'],
      isActive: json['is_active'] == true || json['is_active'] == 1,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}
