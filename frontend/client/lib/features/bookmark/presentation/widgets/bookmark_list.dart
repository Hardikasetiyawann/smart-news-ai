import 'package:flutter/material.dart';
import '../../domain/entities/bookmark_entity.dart';
import 'bookmark_card.dart';

class BookmarkList extends StatelessWidget {
  final List<BookmarkEntity> bookmarks;

  const BookmarkList({
    super.key,
    required this.bookmarks,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        return BookmarkCard(bookmark: bookmarks[index]);
      },
    );
  }
}
