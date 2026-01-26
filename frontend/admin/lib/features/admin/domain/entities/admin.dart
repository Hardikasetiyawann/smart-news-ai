class Admin {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final DateTime? lastLogin;

  Admin({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.lastLogin,
  });
}
