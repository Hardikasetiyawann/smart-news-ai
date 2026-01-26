class ReportEntity {
  /// 'comment' | 'news'
  final String type;

  /// hanya salah satu yang terisi
  final int? commentId;
  final int? newsId;

  /// alasan laporan
  final String content;

  const ReportEntity({
    required this.type,
    this.commentId,
    this.newsId,
    required this.content,
  });
}
