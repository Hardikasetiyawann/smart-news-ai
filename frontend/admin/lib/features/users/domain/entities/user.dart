class User {
  final int id;
  final String? fullName;
  final String? email;
  final String? imageUrl;
  final String? authProvider;
  final bool isActive;
  final DateTime? createdAt;

  const User({
    required this.id,
    this.fullName,
    this.email,
    this.imageUrl,
    this.authProvider,
    required this.isActive,
    this.createdAt,
  });
}
