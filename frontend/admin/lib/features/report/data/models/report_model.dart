import '../../domain/entities/report.dart';

class ReportModel extends Report {
  ReportModel({
    required super.id,
    required super.userId,
    required super.type,
    super.newsId,
    super.commentId,
    required super.content,
    required super.status,
    required super.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      newsId: json['news_id'],
      commentId: json['comment_id'],
      content: json['content'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
