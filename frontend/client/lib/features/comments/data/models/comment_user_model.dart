import '../../domain/entities/comment_user_entity.dart';

class CommentUserModel extends CommentUserEntity {
  const CommentUserModel({
    required super.id,
    required super.fullName,
    super.imageUrl,
  });

  factory CommentUserModel.fromJson(Map<String, dynamic> json) {
    return CommentUserModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? 'User',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
