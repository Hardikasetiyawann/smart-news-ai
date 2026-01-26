class SearchNews {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime publishedAt;
  final int views;

  const SearchNews({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
    required this.views,
  });
}
