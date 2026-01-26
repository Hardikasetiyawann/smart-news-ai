class RecentNews {
  final int id;
  final String title;
  final String status;
  final DateTime createdAt;
  final int viewCount;
  final String publisherName;

  const RecentNews({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.viewCount,
    required this.publisherName,
  });
}
