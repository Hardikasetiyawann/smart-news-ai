abstract class CommentEvent {}

class LoadCommentsByNews extends CommentEvent {
  final int newsId;
  LoadCommentsByNews(this.newsId);
}

class LoadCommentDetail extends CommentEvent {
  final int id;
  LoadCommentDetail(this.id);
}

class DeleteCommentEvent extends CommentEvent {
  final int id;

  DeleteCommentEvent({required this.id});
}
