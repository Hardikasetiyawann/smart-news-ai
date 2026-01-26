class CommentUserEntity {
  final int id;
  final String fullName;
  final String? imageUrl;

  const CommentUserEntity({
    required this.id,
    required this.fullName,
    this.imageUrl,
  });

  /// Inisial nama untuk fallback avatar
  String get initial {
    if (fullName.trim().isEmpty) return '?';
    return fullName.trim()[0].toUpperCase();
  }
}
