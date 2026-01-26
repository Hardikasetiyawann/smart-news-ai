import '../entities/bookmark_entity.dart';
import '../repositories/bookmark_repository.dart';

class AddBookmark {
  final BookmarkRepository repository;

  AddBookmark(this.repository);

  Future<void> call(BookmarkEntity bookmark) {
    return repository.addBookmark(bookmark);
  }
}
