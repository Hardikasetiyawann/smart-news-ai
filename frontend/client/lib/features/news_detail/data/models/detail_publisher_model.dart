import '../../domain/entities/detail_publisher_entity.dart';

class DetailPublisherModel extends DetailPublisherEntity {
  const DetailPublisherModel({
    required super.id,
    required super.name,
    super.logoUrl,
    super.website,
  });

  factory DetailPublisherModel.fromJson(Map<String, dynamic> json) {
    return DetailPublisherModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logoUrl: json['logo_url'],
      website: json['website'],
    );
  }
}
