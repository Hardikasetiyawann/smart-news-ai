import '../../domain/entities/publisher.dart';

class PublisherModel extends Publisher {
  PublisherModel({
    required super.id,
    required super.name,
    super.logoUrl,
    super.website,
  });

  factory PublisherModel.fromJson(Map<String, dynamic> json) {
    return PublisherModel(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logo_url'],
      website: json['website'],
    );
  }
}
