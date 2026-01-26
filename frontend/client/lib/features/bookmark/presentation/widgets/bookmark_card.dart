import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/bookmark_entity.dart';
import '../pages/bookmark_detail_page.dart';
import '../bloc/bookmark_bloc.dart';
import '../bloc/bookmark_event.dart';

class BookmarkCard extends StatelessWidget {
  final BookmarkEntity bookmark;

  const BookmarkCard({
    super.key,
    required this.bookmark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookmarkDetailPage(bookmark: bookmark),
          ),
        );
      },

      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                width: 90,
                height: 90,
                child: Hero(
                  tag: bookmark.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: bookmark.imageUrl.isNotEmpty
                        ? Image.network(
                            bookmark.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported),
                          ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bookmark.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              context.read<BookmarkBloc>().add(
                                    RemoveBookmarkEvent(bookmark.id),
                                  );
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Hapus'),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      bookmark.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundImage:
                              NetworkImage(bookmark.publisherLogo),
                          onBackgroundImageError: (_, __) {},
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${bookmark.publisher} • ${bookmark.time}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
