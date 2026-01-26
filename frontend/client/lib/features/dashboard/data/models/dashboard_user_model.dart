import '../../domain/entities/dashboard_user_entity.dart';

class DashboardUserModel extends DashboardUserEntity {
  const DashboardUserModel({
    required super.id,
    required super.fullName,
    required super.imageUrl,
  });

  factory DashboardUserModel.fromJson(Map<String, dynamic> json) {
    return DashboardUserModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
