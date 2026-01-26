import '../../domain/entities/comment_entity.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final int newsId;
  final List<CommentEntity> comments;
  final bool isSubmitting;
  final String? errorMessage;

  CommentLoaded({
    required this.newsId,
    required this.comments,
    this.isSubmitting = false,
    this.errorMessage,
  });

  CommentLoaded copyWith({
    List<CommentEntity>? comments,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return CommentLoaded(
      newsId: newsId,
      comments: comments ?? this.comments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

class CommentError extends CommentState {
  final String message;

  CommentError(this.message);
}
