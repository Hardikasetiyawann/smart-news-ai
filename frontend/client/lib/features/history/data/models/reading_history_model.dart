import '../../domain/entities/reading_history.dart';
import 'news_model.dart';

class ReadingHistoryModel extends ReadingHistory {
  ReadingHistoryModel({
    required super.id,
    required super.readAt,
    required super.news,
  });

  factory ReadingHistoryModel.fromJson(Map<String, dynamic> json) {
    return ReadingHistoryModel(
      id: json['id'],
      readAt: DateTime.parse(json['read_at']),
      news: NewsModel.fromJson(json['news']),
    );
  }
}
