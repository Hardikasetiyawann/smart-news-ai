import '../../domain/entities/search_news.dart';
import '../../../../core/network/dio_client.dart';

class SearchNewsModel extends SearchNews {
  const SearchNewsModel({
    required super.id,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.publishedAt,
    required super.views,
  });

  factory SearchNewsModel.fromJson(Map<String, dynamic> json) {
    return SearchNewsModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: _resolveImageUrl(json['image_url']),
      publishedAt: DateTime.tryParse(json['published_at'] ?? '') ??
          DateTime.now(),
      views: int.tryParse(json['count_view']?.toString() ?? '0') ?? 0,
    );
  }

  static String _resolveImageUrl(dynamic value) {
    if (value == null) return '';
    final path = value.toString().trim();
    if (path.isEmpty) return '';
    return '${DioClient.dio.options.baseUrl}$path';
  }
}