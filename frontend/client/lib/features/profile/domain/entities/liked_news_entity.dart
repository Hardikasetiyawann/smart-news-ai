class LikedNewsEntity {
  final int id;
  final String title;
  final String imageUrl;
  final String publisherName;
  final String? publishedAt;

  const LikedNewsEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.publisherName,
    required this.publishedAt,
  });
}