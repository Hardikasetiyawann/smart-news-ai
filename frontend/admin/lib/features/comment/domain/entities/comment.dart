class Comment {
  final int id;
  final int? userId;
  final String userName;
  final String? userImage;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.content,
    required this.createdAt,
  });
}
