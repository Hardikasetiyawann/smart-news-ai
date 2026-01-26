import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../../core/utils/number_formatter.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../domain/entities/detail_news_entity.dart';

class DetailHeader extends StatelessWidget {
  final DetailNewsEntity news;

  const DetailHeader({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // KATEGORI
        Text(
          news.category.name.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.green,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),

        // JUDUL
        Text(
          news.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 10),

        // META ROW
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // PUBLISHER + TIME
            Row(
              children: [
                Text(
                  news.publisher.name,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(width: 6),
                const Text('•', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 6),
                Text(
                  TimeFormatter.timeAgo(news.publishedAt),
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),

            // VIEWS
            Row(
              children: [
                const Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  l10n.dashboardViews(
                    NumberFormatter.compact(news.countView),),
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

}
