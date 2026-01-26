import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../domain/entities/dashboard_publisher_entity.dart';
import '../../../publishers/presentation/pages/publisher_page.dart';

class DashboardPublisherWidget extends StatelessWidget {
  final List<DashboardPublisherEntity> publishers;

  const DashboardPublisherWidget({super.key, required this.publishers});

  @override
  Widget build(BuildContext context) {
    if (publishers.isEmpty) return const SizedBox();

    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              l10n.dashboardPublishers,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),

          // daftar publisher horizontal
          SizedBox(
            height: 110,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: publishers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final p = publishers[index];
                final logoUrl = (p.logoUrl != null && p.logoUrl!.isNotEmpty)
                    ? p.logoUrl
                    : null;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 260),
                        pageBuilder: (_, animation, __) => PublisherPage(
                          publisherId: p.id,
                          publisherName: p.name,
                        ),
                        transitionsBuilder: (_, animation, __, child) {
                          final offsetTween = Tween<Offset>(
                            begin: const Offset(0, 0.04),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeOut));

                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: animation.drive(offsetTween),
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  },

                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // logo publisher
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.surfaceContainerHighest,
                            ),
                            child: ClipOval(
                              child: logoUrl != null
                                  ? Image.network(
                                      logoUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _fallbackIcon(colorScheme),
                                    )
                                  : _fallbackIcon(colorScheme),
                            ),
                          ),

                          const SizedBox(height: 6),

                          // nama publisher
                          SizedBox(
                            width: 64,
                            child: Text(
                              p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
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

  Widget _fallbackIcon(ColorScheme colorScheme) {
    return Icon(Icons.public, size: 22, color: colorScheme.onSurfaceVariant);
  }
}
