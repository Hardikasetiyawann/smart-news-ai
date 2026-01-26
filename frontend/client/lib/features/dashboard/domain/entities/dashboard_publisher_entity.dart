class DashboardPublisherEntity {
  final int id;
  final String name;
  final String? logoUrl;
  final String? website;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DashboardPublisherEntity({
    required this.id,
    required this.name,
    this.logoUrl,
    this.website,
    required this.createdAt,
    required this.updatedAt,
  });
}
