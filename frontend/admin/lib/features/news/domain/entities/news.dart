class News {
  final int id;
  final int categoryId;
  final int publisherId;
  final int adminId;
  final String title;
  final String content;
  final String imageUrl;
  final String linkNews;
  final String status;
  final int countView;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  News({
    required this.id,
    required this.categoryId,
    required this.publisherId,
    required this.adminId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.linkNews,
    required this.status,
    required this.countView,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
