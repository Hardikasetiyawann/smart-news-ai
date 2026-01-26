import '../../../../core/network/dio_client.dart';
import '../../domain/entities/detail_news_entity.dart';
import 'detail_category_model.dart';
import 'detail_publisher_model.dart';

class DetailNewsModel extends DetailNewsEntity {
  const DetailNewsModel({
    required super.id,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.linkNews,
    required super.publishedAt,
    required super.countView,
    required super.category,
    required super.publisher,
  });

  factory DetailNewsModel.fromJson({
    required Map<String, dynamic> newsJson,
    required Map<String, dynamic> categoryJson,
    required Map<String, dynamic> publisherJson,
  }) {
    return DetailNewsModel(
      id: newsJson['id'] ?? 0,
      title: newsJson['title'] ?? '',
      content: newsJson['content'] ?? '',
      imageUrl: _resolveImageUrl(newsJson['image_url']),
      linkNews: newsJson['link_news'] ?? '',
      publishedAt: _parseDate(newsJson['published_at']),
      countView: newsJson['count_view'] ?? 0,
      category: DetailCategoryModel.fromJson(categoryJson),
      publisher: DetailPublisherModel.fromJson(publisherJson),
    );
  }

  // penambahan dio client untuk resolve image url
  static String _resolveImageUrl(dynamic value) {
    if (value == null) return '';

    final path = value.toString().trim();
    if (path.isEmpty) return '';

    return '${DioClient.dio.options.baseUrl}$path';
  }

  // parsing date dengan fallback ke epoch jika gagal
  static DateTime _parseDate(dynamic value) {
    if (value == null) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return DateTime.tryParse(value.toString()) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }
}
