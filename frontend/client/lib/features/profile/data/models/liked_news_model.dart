import '../../domain/entities/liked_news_entity.dart';

class LikedNewsModel extends LikedNewsEntity {
  const LikedNewsModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.publisherName,
    required super.publishedAt,
  });

  factory LikedNewsModel.fromJson(Map<String, dynamic> json) {
    return LikedNewsModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'], 
      publisherName: json['publisher'], 
      publishedAt: json['publishedAt'], 
    );
  }
}