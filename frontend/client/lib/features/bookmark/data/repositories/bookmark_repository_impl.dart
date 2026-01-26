import '../../domain/entities/bookmark_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_local_datasource.dart';
import '../models/bookmark_model.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDataSource localDataSource;

  BookmarkRepositoryImpl(this.localDataSource);

  @override
  Future<void> addBookmark(BookmarkEntity bookmark) async {
    final model = BookmarkModel(
      id: bookmark.id,
      title: bookmark.title,
      imageUrl: bookmark.imageUrl,
      category: bookmark.category,
      publisher: bookmark.publisher,
      publisherLogo: bookmark.publisherLogo,
      time: bookmark.time,
      content: bookmark.content,
    );

    await localDataSource.addBookmark(model);
  }

  @override
  Future<void> removeBookmark(String id) {
    return localDataSource.removeBookmark(id);
  }

  @override
  Future<List<BookmarkEntity>> getBookmarks() async {
    return await localDataSource.getBookmarks();
  }

  @override
  Future<bool> isBookmarked(String id) {
    return localDataSource.isBookmarked(id);
  }

  @override
  Future<void> clearBookmarks() {
    return localDataSource.clearBookmarks();
  }
}
