class Report {
  final int id;
  final int userId;
  final String type; // news | comment
  final int? newsId;
  final int? commentId;
  final String content;
  final String status; // pending | resolved
  final DateTime createdAt;

  Report({
    required this.id,
    required this.userId,
    required this.type,
    this.newsId,
    this.commentId,
    required this.content,
    required this.status,
    required this.createdAt,
  });
}
