import '../repositories/bookmark_repository.dart';

class RemoveBookmark {
  final BookmarkRepository repository;

  RemoveBookmark(this.repository);

  Future<void> call(String id) {
    return repository.removeBookmark(id);
  }
}
