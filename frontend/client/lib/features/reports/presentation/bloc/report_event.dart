abstract class ReportEvent {}

class ReportSubmitRequested extends ReportEvent {
  final String type; // "comment" | "news"
  final int? commentId;
  final int? newsId;
  final String content;

  ReportSubmitRequested({
    required this.type,
    this.commentId,
    this.newsId,
    required this.content,
  });
}
