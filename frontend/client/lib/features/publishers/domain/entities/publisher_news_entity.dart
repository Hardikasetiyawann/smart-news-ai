class PublisherNewsEntity {
  final int id;
  final String title;
  final String imageUrl;
  final DateTime publishedAt;
  final int countView;

  const PublisherNewsEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.publishedAt,
    required this.countView,
  });
}
