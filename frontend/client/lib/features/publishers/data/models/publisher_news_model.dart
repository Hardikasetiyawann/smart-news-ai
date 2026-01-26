import '../../../../core/network/dio_client.dart';
import '../../domain/entities/publisher_news_entity.dart';

class PublisherNewsModel extends PublisherNewsEntity {
  const PublisherNewsModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.publishedAt,
    required super.countView,
  });

  factory PublisherNewsModel.fromJson(Map<String, dynamic> json) {
    final rawImage = json['image_url'] ?? '';

    final imageUrl = rawImage.startsWith('http')
        ? rawImage
        : '${DioClient.dio.options.baseUrl}$rawImage';

    return PublisherNewsModel(
      id: json['id'],
      title: json['title'],
      imageUrl: imageUrl,
      publishedAt: DateTime.parse(json['published_at']),
      countView: json['count_view'] ?? 0,
    );
  }
}
