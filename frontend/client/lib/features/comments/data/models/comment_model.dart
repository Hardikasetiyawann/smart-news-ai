import '../../domain/entities/comment_entity.dart';
import 'comment_user_model.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.content,
    required super.createdAt,
    required super.isMine,
    required super.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      isMine: json['is_mine'] ?? false,
      user: CommentUserModel.fromJson(json['user']),
    );
  }
}
