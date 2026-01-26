import '../../domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  const ReportModel({
    required super.type,
    super.commentId,
    super.newsId,
    required super.content,
  });

  /// helper untuk body request
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'comment_id': commentId,
      'news_id': newsId,
      'content': content,
    };
  }
}
