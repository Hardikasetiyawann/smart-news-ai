import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/layout/app_scaffold.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

import '../widgets/dashboard_trending_widget.dart';
import '../widgets/dashboard_publisher_widget.dart';
import '../widgets/dashboard_categories_widget.dart';
import '../widgets/dashboard_latest_news_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../notification/presentation/pages/notification_page.dart';
import 'package:client/gen_l10n/app_localizations.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      currentIndex: 0,

      // menampilkan app bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            final bool isLoaded = state is DashboardLoaded;

            final String? imageUrl = isLoaded ? state.user.imageUrl : null;

            final String userName = isLoaded ? state.user.fullName : '';

            return AppBar(
              elevation: 0,
              toolbarHeight: 72,
              titleSpacing: 0,

              // header dengan avatar dan nama user
              title: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : null,
                      child: imageUrl == null || imageUrl.isEmpty
                          ? Icon(
                              Icons.person,
                              color: theme.colorScheme.onSurfaceVariant,
                            )
                          : null,
                    ),

                    const SizedBox(width: 12),

                    // nama user dengan animated switcher
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.dashboardWelcomeBack,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 2),

                        SizedBox(
                          height: 22,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: isLoaded
                                ? Text(
                                    userName,
                                    key: const ValueKey('username'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  )
                                : Container(
                                    key: const ValueKey('username_placeholder'),
                                    width: 120,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // tombol notifikasi
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none),
                    splashRadius: 22,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),

      // body dengan berbagai widget dashboard
      body: BlocBuilder<DashboardBloc, DashboardState>(
        buildWhen: (previous, current) {
          if (previous is DashboardLoaded && current is DashboardLoaded) {
            return previous.trendingNews != current.trendingNews ||
                previous.publishers != current.publishers ||
                previous.categories != current.categories ||
                previous.selectedCategoryId != current.selectedCategoryId;
          }
          return true;
        },
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const LoadingWidget();
          }

          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(LoadDashboard());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardTrendingWidget(
                      news: state.trendingNews,
                      categoryMap: {
                        for (final c in state.categories) c.id: c.name,
                      },
                      publisherMap: {
                        for (final p in state.publishers) p.id: p.name,
                      },
                    ),

                    DashboardPublisherWidget(publishers: state.publishers),

                    DashboardCategoriesWidget(
                      categories: state.categories,
                      selectedId: state.selectedCategoryId,
                      onSelected: (id) {
                        context.read<DashboardBloc>().add(
                          LoadNewsByCategory(id),
                        );
                      },
                    ),

                    BlocBuilder<DashboardBloc, DashboardState>(
                      buildWhen: (previous, current) {
                        if (previous is DashboardLoaded &&
                            current is DashboardLoaded) {
                          return previous.latestNews != current.latestNews;
                        }
                        return false;
                      },
                      builder: (context, latestState) {
                        if (latestState is DashboardLoaded) {
                          return DashboardLatestNewsWidget(
                            news: latestState.latestNews,
                          );
                        }

                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: LoadingWidget(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is DashboardError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
