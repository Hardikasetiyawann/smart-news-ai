import '../../domain/entities/detail_category_entity.dart';

class DetailCategoryModel extends DetailCategoryEntity {
  const DetailCategoryModel({required super.id, required super.name});

  factory DetailCategoryModel.fromJson(Map<String, dynamic> json) {
    return DetailCategoryModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
