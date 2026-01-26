import '../entities/bookmark_entity.dart';
import '../repositories/bookmark_repository.dart';

class GetBookmarks {
  final BookmarkRepository repository;

  GetBookmarks(this.repository);

  Future<List<BookmarkEntity>> call() {
    return repository.getBookmarks();
  }
}
