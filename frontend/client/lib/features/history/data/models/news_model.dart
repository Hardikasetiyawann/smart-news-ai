import '../../../../core/entities/news.dart';

class NewsModel extends News {
  const NewsModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    super.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'],
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,
    );
  }
}
