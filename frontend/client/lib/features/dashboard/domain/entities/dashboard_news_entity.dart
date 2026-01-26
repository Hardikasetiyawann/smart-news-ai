enum NewsStatus { draft, published }

class DashboardNewsEntity {
  final int id;
  final int adminId;
  final int categoryId;
  final int publisherId;

  final String title;
  final String content;
  final String imageUrl;
  final String linkNews;

  final NewsStatus status;
  final int countView;
  final DateTime? publishedAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  const DashboardNewsEntity({
    required this.id,
    required this.adminId,
    required this.categoryId,
    required this.publisherId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.linkNews,
    required this.status,
    required this.countView,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
