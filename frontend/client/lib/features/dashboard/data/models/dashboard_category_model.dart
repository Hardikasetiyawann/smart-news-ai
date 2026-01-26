import '../../domain/entities/dashboard_category_entity.dart';

class DashboardCategoryModel extends DashboardCategoryEntity {
  DashboardCategoryModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DashboardCategoryModel.fromJson(Map<String, dynamic> json) {
    return DashboardCategoryModel(
      id: int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
