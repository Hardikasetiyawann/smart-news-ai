import 'package:equatable/equatable.dart';
import '../../domain/entities/bookmark_entity.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object?> get props => [];
}

class LoadBookmarks extends BookmarkEvent {}
class AddBookmarkEvent extends BookmarkEvent {
  final BookmarkEntity bookmark;

  const AddBookmarkEvent(this.bookmark);

  @override
  List<Object?> get props => [bookmark];
}

class RemoveBookmarkEvent extends BookmarkEvent {
  final String id;

  const RemoveBookmarkEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CheckBookmarkStatus extends BookmarkEvent {
  final String id;

  const CheckBookmarkStatus(this.id);

  @override
  List<Object?> get props => [id];
}


class ClearAllBookmarks extends BookmarkEvent {}
