import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userImage,
    required super.content,
    required super.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];

    return CommentModel(
      id: json['id'],
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      userId: user?['id'],
      userName: user?['full_name'] ?? 'Anonim',
      userImage: user?['image_url'],
    );
  }
}
