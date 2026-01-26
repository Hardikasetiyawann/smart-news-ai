import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../news_detail/presentation/navigation/detail_navigation.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../domain/entities/dashboard_news_entity.dart';

class DashboardLatestNewsWidget extends StatelessWidget {
  final List<DashboardNewsEntity> news;

  const DashboardLatestNewsWidget({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // menampilkan pesan jika tidak ada berita
    if (news.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            l10n.dashboardEmptyNews,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }
    // menampilkan daftar berita
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 500;
        final imageSize = isTablet ? 120.0 : 90.0;
        final titleFont = isTablet ? 15.5 : 14.0;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: news.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 2 : 1,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
              childAspectRatio: isTablet ? 3.4 : 3.8,
            ),
            itemBuilder: (context, index) {
              final item = news[index];
              // setiap item berita
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => goToNewsDetail(context, item.id),

                child: Card(
                  margin: EdgeInsets.zero, // grid sudah atur spacing
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // image berita
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
                                color: colorScheme.surfaceContainerHighest,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.broken_image,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 14),

                        // judul dan info berita
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                maxLines: isTablet ? 3 : 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontSize: titleFont,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  Text(
                                    TimeFormatter.timeAgoNull(item.publishedAt),
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '•',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    l10n.dashboardViews(
                                      NumberFormatter.compact(item.countView),
                                    ),
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
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
            },
          ),
        );
      },
    );
  }
}
