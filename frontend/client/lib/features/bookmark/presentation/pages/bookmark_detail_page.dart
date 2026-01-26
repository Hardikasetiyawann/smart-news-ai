import 'package:flutter/material.dart';
import '../../domain/entities/bookmark_entity.dart';

class BookmarkDetailPage extends StatelessWidget {
  final BookmarkEntity bookmark;

  const BookmarkDetailPage({
    super.key,
    required this.bookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bookmark.imageUrl.isNotEmpty)
              Hero(
                tag: bookmark.id, 
                child: SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: Image.network(
                    bookmark.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookmark.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    bookmark.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage:
                            NetworkImage(bookmark.publisherLogo),
                        onBackgroundImageError: (_, __) {},
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${bookmark.publisher} • ${bookmark.time}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    bookmark.content,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
