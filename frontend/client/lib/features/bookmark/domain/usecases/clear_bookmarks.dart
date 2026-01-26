import '../repositories/bookmark_repository.dart';

class ClearBookmarks {
  final BookmarkRepository repository;

  ClearBookmarks(this.repository);

  Future<void> call() {
    return repository.clearBookmarks();
  }
}
