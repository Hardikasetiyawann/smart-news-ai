import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_comments_by_news.dart';
import '../../domain/usecases/get_comment_by_id.dart';
import '../../domain/usecases/delete_comment.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetCommentsByNews getByNews;
  final GetCommentById getById;
  final DeleteComment deleteComment;

  CommentBloc({
    required this.getByNews,
    required this.getById,
    required this.deleteComment,
  }) : super(CommentInitial()) {
    on<LoadCommentsByNews>(_onLoadByNews);
    on<LoadCommentDetail>(_onLoadDetail);
    on<DeleteCommentEvent>(_onDelete);
  }

  Future<void> _onLoadByNews(
    LoadCommentsByNews e,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoading());
    try {
      final data = await getByNews(e.newsId);
      emit(CommentListLoaded(data));
    } catch (err) {
      emit(CommentError(err.toString()));
    }
  }

  Future<void> _onLoadDetail(
    LoadCommentDetail e,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoading());
    try {
      final comment = await getById(e.id);
      emit(CommentDetailLoaded(comment));
    } catch (err) {
      emit(CommentError(err.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteCommentEvent e,
    Emitter<CommentState> emit,
  ) async {
    try {
      await deleteComment(e.id);
      emit(CommentDeleted()); // ✅ CUKUP INI
    } catch (err) {
      emit(CommentError(err.toString()));
    }
  }
}
