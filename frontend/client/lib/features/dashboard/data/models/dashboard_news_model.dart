import '../../../../core/network/dio_client.dart';
import '../../domain/entities/dashboard_news_entity.dart';

class DashboardNewsModel extends DashboardNewsEntity {
  DashboardNewsModel({
    required super.id,
    required super.adminId,
    required super.categoryId,
    required super.publisherId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.linkNews,
    required super.status,
    required super.countView,
    super.publishedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DashboardNewsModel.fromJson(Map<String, dynamic> json) {
    return DashboardNewsModel(
      id: int.parse(json['id'].toString()),
      adminId: int.parse(json['admin_id'].toString()),
      categoryId: int.parse(json['category_id'].toString()),
      publisherId: int.parse(json['publisher_id'].toString()),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: _resolveImageUrl(json['image_url']),
      linkNews: json['link_news'] ?? '',
      status: _parseStatus(json['status']),
      countView: int.parse(json['count_view'].toString()),
      publishedAt: _parseDate(json['published_at']),
      createdAt: _parseDate(json['created_at'])!,
      updatedAt: _parseDate(json['updated_at'])!,
    );
  }

  // penambahan dio client untuk resolve image url
  static String _resolveImageUrl(dynamic value) {
    if (value == null) return '';

    final path = value.toString().trim();
    if (path.isEmpty) return '';

    return '${DioClient.dio.options.baseUrl}$path';
  }

  static NewsStatus _parseStatus(dynamic value) {
    return value == 'draft' ? NewsStatus.draft : NewsStatus.published;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
