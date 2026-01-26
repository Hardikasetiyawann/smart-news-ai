import '../repositories/bookmark_repository.dart';

class IsBookmarked {
  final BookmarkRepository repository;

  IsBookmarked(this.repository);

  Future<bool> call(String id) {
    return repository.isBookmarked(id);
  }
}
