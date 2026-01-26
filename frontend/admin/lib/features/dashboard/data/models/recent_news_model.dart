import '../../domain/entities/recent_news.dart';

class RecentNewsModel extends RecentNews {
  const RecentNewsModel({
    required super.id,
    required super.title,
    required super.status,
    required super.createdAt,
    required super.viewCount,
    required super.publisherName,
  });

  factory RecentNewsModel.fromJson(Map<String, dynamic> json) {
    return RecentNewsModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      viewCount: json['count_view'],
      publisherName: json['publisher']['name'],
    );
  }
}
