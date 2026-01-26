import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_bookmark.dart';
import '../../domain/usecases/remove_bookmark.dart';
import '../../domain/usecases/get_bookmarks.dart';
import '../../domain/usecases/is_bookmarked.dart';
import '../../domain/usecases/clear_bookmarks.dart';
import 'bookmark_event.dart';
import 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final AddBookmark addBookmark;
  final RemoveBookmark removeBookmark;
  final GetBookmarks getBookmarks;
  final IsBookmarked isBookmarked;
  final ClearBookmarks clearBookmarks;

  BookmarkBloc({
    required this.addBookmark,
    required this.removeBookmark,
    required this.getBookmarks,
    required this.isBookmarked,
    required this.clearBookmarks,
  }) : super(const BookmarkState()) {
    on<LoadBookmarks>(_onLoadBookmarks);
    on<AddBookmarkEvent>(_onAddBookmark);
    on<RemoveBookmarkEvent>(_onRemoveBookmark);
    on<CheckBookmarkStatus>(_onCheckBookmark);
    on<ClearAllBookmarks>(_onClearAll);
  }

  Future<void> _onLoadBookmarks(
    LoadBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));

    try {
      final bookmarks = await getBookmarks();
      emit(state.copyWith(isLoading: false, bookmarks: bookmarks));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'Gagal memuat bookmark'),
      );
    }
  }

  Future<void> _onAddBookmark(
    AddBookmarkEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      await addBookmark(event.bookmark);
      emit(state.copyWith(isBookmarked: true));
      add(LoadBookmarks());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Gagal menambahkan bookmark'));
    }
  }

  Future<void> _onRemoveBookmark(
    RemoveBookmarkEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      await removeBookmark(event.id);
      emit(state.copyWith(isBookmarked: false));
      add(LoadBookmarks());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Gagal menghapus bookmark'));
    }
  }

  Future<void> _onCheckBookmark(
    CheckBookmarkStatus event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      final result = await isBookmarked(event.id);
      emit(state.copyWith(isBookmarked: result));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Gagal mengecek bookmark'));
    }
  }

  Future<void> _onClearAll(
    ClearAllBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      await clearBookmarks();
      emit(const BookmarkState());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Gagal menghapus semua bookmark'));
    }
  }
}
