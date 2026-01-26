import 'package:client/features/news_detail/domain/entities/detail_publisher_entity.dart';

import 'detail_category_entity.dart';

class DetailNewsEntity {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final String linkNews;
  final DateTime publishedAt;
  final int countView;

  final DetailCategoryEntity category;
  final DetailPublisherEntity publisher;

  const DetailNewsEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.linkNews,
    required this.publishedAt,
    required this.countView,
    required this.category,
    required this.publisher,
  });
}
