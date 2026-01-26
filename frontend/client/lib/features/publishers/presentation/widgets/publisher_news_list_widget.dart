import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../../core/utils/number_formatter.dart';
import '../../../../core/utils/time_formatter.dart';

class NewsListItem {
  final int id;
  final String title;
  final String imageUrl;
  final DateTime publishedAt;
  final int countView;

  const NewsListItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.publishedAt,
    required this.countView,
  });
}

class NewsListWidget extends StatelessWidget {
  final List<NewsListItem> news;
  final void Function(int newsId) onTap;

  const NewsListWidget({super.key, required this.news, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context); // ✅ FIX UTAMA

    if (news.isEmpty) {
      return const Center(child: Text('Tidak ada berita'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 500;
        final imageSize = isTablet ? 120.0 : 90.0;
        final titleFont = isTablet ? 15.5 : 14.0;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: news.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 2 : 1,
            mainAxisSpacing: 20,
            crossAxisSpacing: 16,
            childAspectRatio: isTablet ? 3.4 : 3.8,
          ),
          itemBuilder: (context, index) {
            final item = news[index];

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onTap(item.id),

              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= IMAGE =================
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item.imageUrl,
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              width: imageSize,
                              height: imageSize,
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.broken_image,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 14),

                      // ================= TEXT =================
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: isTablet ? 3 : 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: titleFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Text(
                                  TimeFormatter.timeAgoNull(item.publishedAt),
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                const SizedBox(width: 6),
                                const Text('•'),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.dashboardViews(
                                    NumberFormatter.compact(item.countView),
                                  ),
                                  style: Theme.of(context).textTheme.labelSmall,
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
          },
        );
      },
    );
  }
}
