abstract class CommentEvent {}

class CommentLoadRequested extends CommentEvent {
  final int newsId;

  CommentLoadRequested(this.newsId);
}

class CommentAddRequested extends CommentEvent {
  final int newsId;
  final String content;

  CommentAddRequested({required this.newsId, required this.content});
}

class CommentUpdateRequested extends CommentEvent {
  final int commentId;
  final String content;

  CommentUpdateRequested({required this.commentId, required this.content});
}

class CommentDeleteRequested extends CommentEvent {
  final int commentId;

  CommentDeleteRequested(this.commentId);
}
