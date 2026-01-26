import '../../domain/entities/news.dart';

class NewsModel extends News {
  NewsModel({
    required super.id,
    required super.categoryId,
    required super.publisherId,
    required super.adminId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.linkNews,
    required super.status,
    required super.countView,
    required super.publishedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      categoryId: json['category_id'],
      publisherId: json['publisher_id'],
      adminId: json['admin_id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['image_url'],
      linkNews: json['link_news'],
      status: json['status'],
      countView: json['count_view'] ?? 0,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
