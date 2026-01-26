import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../../core/layout/app_scaffold.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../news_detail/presentation/pages/detail_page.dart';

import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<NotificationBloc>().add(
      const LoadNotifications(refresh: true),
    );

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationBloc>().add(LoadMoreNotifications());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    final content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop
              ? 900
              : isTablet
              ? 700
              : double.infinity,
        ),
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationInitial || state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationEmpty) {
              return Center(child: Text(l10n.noNotifications));
            }

            if (state is NotificationLoaded) {
              final grouped = _groupByDate(state.notifications);

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: grouped.length + (state.hasReachedMax ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index == grouped.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  final entry = grouped.entries.elementAt(index);
                  return _buildSection(context, entry.key, entry.value);
                },
              );
            }

            if (state is NotificationError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.notifications), centerTitle: true),
        body: content,
      );
    }

    return AppScaffold(
      currentIndex: 3,
      appBar: AppBar(title: Text(l10n.notifications), centerTitle: false),
      body: content,
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<NotificationEntity> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleSmall),
        ),
        ...items.map((n) => _buildItem(context, n)),
      ],
    );
  }

  Widget _buildItem(BuildContext context, NotificationEntity notification) {
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<NotificationBloc>().add(
          DeleteNotificationEvent(notification.id),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: notification.isRead
              ? Colors.grey.shade300
              : Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.notifications, color: Colors.white),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Text(
          notification.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          _timeAgo(notification.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),

        onTap: () async {
          if (!notification.isRead) {
            context.read<NotificationBloc>().add(
              MarkNotificationReadEvent(notification.id),
            );
          }

          if (notification.newsId != null) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPage(newsId: notification.newsId!),
              ),
            );

            if (!context.mounted) return;

            context.read<NotificationBloc>().add(
              const LoadNotifications(refresh: true),
            );
          }
        },
      ),
    );
  }

  Map<String, List<NotificationEntity>> _groupByDate(
    List<NotificationEntity> notifications,
  ) {
    final Map<String, List<NotificationEntity>> map = {};
    final l10n = AppLocalizations.of(context);

    for (final n in notifications) {
      final date = DateUtils.dateOnly(n.createdAt);
      final now = DateUtils.dateOnly(DateTime.now());

      String key;
      if (date == now) {
        key = l10n.notificationToday(DateFormat('d MMMM').format(date));
      } else if (date == now.subtract(const Duration(days: 1))) {
        key = l10n.notificationYesterday(DateFormat('d MMMM').format(date));
      } else {
        key = DateFormat('d MMMM yyyy').format(date);
      }

      map.putIfAbsent(key, () => []).add(n);
    }

    return map;
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else {
      return '${diff.inDays}d';
    }
  }
}
