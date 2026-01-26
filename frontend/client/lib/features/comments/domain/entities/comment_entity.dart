import 'comment_user_entity.dart';

class CommentEntity {
  final int id;
  final String content;
  final DateTime createdAt;
  final bool isMine;
  final CommentUserEntity user;

  const CommentEntity({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.isMine,
    required this.user,
  });
}
