import '../../../../core/entities/news.dart';

class ReadingHistory {
  final int id;
  final DateTime readAt;
  final News news;

  const ReadingHistory({
    required this.id,
    required this.readAt,
    required this.news,
  });
}
