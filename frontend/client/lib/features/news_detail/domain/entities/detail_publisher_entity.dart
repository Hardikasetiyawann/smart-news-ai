class DetailPublisherEntity {
  final int id;
  final String name;
  final String? logoUrl;
  final String? website;

  const DetailPublisherEntity({
    required this.id,
    required this.name,
    this.logoUrl,
    this.website,
  });
}
