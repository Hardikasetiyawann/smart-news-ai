class UserEntity {
  final int id;
  final String email;
  final String fullName;
  final String? imageUrl;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.imageUrl,
  });
}