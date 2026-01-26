import 'package:equatable/equatable.dart';
import '../../domain/entities/bookmark_entity.dart';

class BookmarkState extends Equatable {
  final bool isLoading;
  final List<BookmarkEntity> bookmarks;
  final bool isBookmarked;
  final String errorMessage;

  const BookmarkState({
    this.isLoading = false,
    this.bookmarks = const [],
    this.isBookmarked = false,
    this.errorMessage = '',
  });

  BookmarkState copyWith({
    bool? isLoading,
    List<BookmarkEntity>? bookmarks,
    bool? isBookmarked,
    String? errorMessage,
  }) {
    return BookmarkState(
      isLoading: isLoading ?? this.isLoading,
      bookmarks: bookmarks ?? this.bookmarks,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, bookmarks, isBookmarked, errorMessage];
}
