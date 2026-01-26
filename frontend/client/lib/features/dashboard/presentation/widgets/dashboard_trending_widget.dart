import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../news_detail/presentation/navigation/detail_navigation.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../domain/entities/dashboard_news_entity.dart';

class DashboardTrendingWidget extends StatefulWidget {
  final List<DashboardNewsEntity> news;
  final Map<int, String> categoryMap;
  final Map<int, String> publisherMap;

  const DashboardTrendingWidget({
    super.key,
    required this.news,
    required this.categoryMap,
    required this.publisherMap,
  });

  @override
  State<DashboardTrendingWidget> createState() =>
      _DashboardTrendingWidgetState();
}

class _DashboardTrendingWidgetState extends State<DashboardTrendingWidget> {
  late final PageController _controller;

  static const int _initialPage = 1000;
  static const double _cardHeight = 340; // tinggi aman & stabil

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 1,
      initialPage: _initialPage,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.news.isEmpty) return const SizedBox();

    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final trending = widget.news.take(5).toList();
    final total = trending.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              l10n.dashboardTrending,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ================= TRENDING PAGEVIEW =================
          SizedBox(
            height: _cardHeight,
            child: PageView.builder(
              controller: _controller,
              itemBuilder: (context, index) {
                final item = trending[index % total];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => goToNewsDetail(context, item.id),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(14),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ================= IMAGE =================
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                item.imageUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Container(
                                    height: 200,
                                    width: double.infinity,
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

                            const SizedBox(height: 10),

                            // ================= CATEGORY =================
                            Text(
                              widget.categoryMap[item.categoryId] ??
                                  l10n.dashboardCategoryFallback,
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // ================= TITLE =================
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // ================= META INFO =================
                            Row(
                              children: [
                                Text(
                                  widget.publisherMap[item.publisherId] ??
                                      l10n.dashboardPublisherFallback,
                                  style: textTheme.labelSmall,
                                ),
                                const SizedBox(width: 6),
                                const Text('•'),
                                const SizedBox(width: 6),
                                Text(
                                  TimeFormatter.timeAgoNull(item.publishedAt),
                                  style: textTheme.labelSmall,
                                ),
                                const SizedBox(width: 6),
                                const Text('•'),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.dashboardViews(
                                    NumberFormatter.compact(item.countView),
                                  ),
                                  style: textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
