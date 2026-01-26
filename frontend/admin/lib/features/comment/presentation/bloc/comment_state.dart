import '../../domain/entities/comment.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentListLoaded extends CommentState {
  final List<Comment> comments;
  CommentListLoaded(this.comments);
}

class CommentDetailLoaded extends CommentState {
  final Comment comment;
  CommentDetailLoaded(this.comment);
}

class CommentError extends CommentState {
  final String message;
  CommentError(this.message);
}

class CommentDeleted extends CommentState {}
