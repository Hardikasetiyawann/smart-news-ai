import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/get_comments.dart';
import '../../domain/usecase/add_comment.dart';
import '../../domain/usecase/update_comment.dart';
import '../../domain/usecase/delete_comment.dart';

import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetComments getComments;
  final AddComment addComment;
  final UpdateComment updateComment;
  final DeleteComment deleteComment;

  CommentBloc({
    required this.getComments,
    required this.addComment,
    required this.updateComment,
    required this.deleteComment,
  }) : super(CommentInitial()) {
    on<CommentLoadRequested>(_onLoadRequested);
    on<CommentAddRequested>(_onAddRequested);
    on<CommentUpdateRequested>(_onUpdateRequested);
    on<CommentDeleteRequested>(_onDeleteRequested);
  }

  //load comments
  Future<void> _onLoadRequested(
    CommentLoadRequested event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoading());

    try {
      final comments = await getComments.execute(event.newsId);

      emit(CommentLoaded(newsId: event.newsId, comments: comments));
    } catch (e) {
      emit(CommentError(_mapError(e)));
    }
  }

  // add comment
  Future<void> _onAddRequested(
    CommentAddRequested event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CommentLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, errorMessage: null));

    try {
      await addComment.execute(
        newsId: currentState.newsId,
        content: event.content,
      );

      // refresh comments after adding
      add(CommentLoadRequested(currentState.newsId));
    } catch (e) {
      emit(
        currentState.copyWith(isSubmitting: false, errorMessage: _mapError(e)),
      );
    }
  }

  // update comment
  Future<void> _onUpdateRequested(
    CommentUpdateRequested event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CommentLoaded) return;

    try {
      await updateComment.execute(
        commentId: event.commentId,
        content: event.content,
      );

      add(CommentLoadRequested(currentState.newsId));
    } catch (e) {
      emit(CommentError(_mapError(e)));
    }
  }

  // delete comment
  Future<void> _onDeleteRequested(
    CommentDeleteRequested event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CommentLoaded) return;

    try {
      await deleteComment.execute(event.commentId);
      add(CommentLoadRequested(currentState.newsId));
    } catch (e) {
      emit(CommentError(_mapError(e)));
    }
  }

  // map error messages
  String _mapError(Object error) {
    final msg = error.toString();

    if (msg.contains('Unauthorized')) {
      return 'Silakan login terlebih dahulu';
    }

    if (msg.contains('Failed')) {
      return msg;
    }

    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}
