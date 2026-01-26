import '../entities/bookmark_entity.dart';

abstract class BookmarkRepository {
  Future<List<BookmarkEntity>> getBookmarks();
  Future<void> addBookmark(BookmarkEntity bookmark);
  Future<void> removeBookmark(String id);
  Future<bool> isBookmarked(String id);
  Future<void> clearBookmarks();
}
