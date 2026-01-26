class News {
  final int id;
  final String title;
  final String imageUrl;
  final DateTime? publishedAt;

  const News({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.publishedAt,
  });
}
