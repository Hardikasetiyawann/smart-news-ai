class BookmarkEntity {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final String publisher;
  final String publisherLogo;
  final String time;
  final String content;

  const BookmarkEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.publisher,
    required this.publisherLogo,
    required this.time,
    required this.content,
  });
}
