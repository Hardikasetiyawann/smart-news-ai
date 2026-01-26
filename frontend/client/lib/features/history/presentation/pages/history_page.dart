import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/core/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../core/layout/app_scaffold.dart';
import '../../../../core/responsive/responsive.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../../../news_detail/presentation/navigation/detail_navigation.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);

    final content = BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HistoryLoaded) {
          if (state.history.isEmpty) {
            return Center(
              child: Text(
                l10n.historyEmpty,
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }

          final crossAxisCount = Responsive.isDesktop(context)
              ? 3
              : Responsive.isTablet(context)
              ? 2
              : 1;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isMobile ? 3.8 : 3.2,
            ),
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final item = state.history[index];
              final selected = state.selectedIds.contains(item.news.id);

              return GestureDetector(
                onLongPress: () =>
                    _confirmDeleteSingle(context, l10n, item.news.id),

                onTap: state.selectionMode
                    ? () {
                        context.read<HistoryBloc>().add(
                          ToggleSelectItem(item.news.id),
                        );
                      }
                    : () async {
                        goToNewsDetail(context, item.news.id);

                        if (!context.mounted) return;

                        context.read<HistoryBloc>().add(LoadHistory());
                      },

                child: Stack(
                  children: [
                    _HistoryCard(
                      title: item.news.title,
                      imageUrl: item.news.imageUrl,
                      readAt: item.readAt,
                    ),

                    if (state.selectionMode)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: selected
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        }

        if (state is HistoryError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );

    if (isMobile) {
      return Scaffold(appBar: _buildAppBar(context, l10n), body: content);
    }

    return AppScaffold(
      currentIndex: 0,
      appBar: _buildAppBar(context, l10n),
      body: content,
    );
  }

  AppBar _buildAppBar(BuildContext context, AppLocalizations l10n) {
    final state = context.watch<HistoryBloc>().state;
    final isSelection = state is HistoryLoaded && state.selectionMode;

    final isAllSelected =
        state is HistoryLoaded &&
        state.history.isNotEmpty &&
        state.selectedIds.length == state.history.length;

    return AppBar(
      title: isSelection
          ? Text(l10n.historySelectedCount(state.selectedIds.length))
          : Text(l10n.historyTitle),
      leading: isSelection
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () =>
                  context.read<HistoryBloc>().add(ToggleSelectionMode()),
            )
          : null,
      actions: [
        if (!isSelection)
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(value: 'select', child: Text(l10n.select)),
            ],
            onSelected: (_) =>
                context.read<HistoryBloc>().add(ToggleSelectionMode()),
          ),

        if (isSelection)
          IconButton(
            tooltip: isAllSelected ? l10n.unselectAll : l10n.selectAll,

            icon: Icon(
              isAllSelected ? Icons.check_box : Icons.check_box_outline_blank,
            ),
            onPressed: () =>
                context.read<HistoryBloc>().add(ToggleSelectAllHistory()),
          ),

        if (isSelection)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: state.selectedIds.isEmpty
                ? null
                : () =>
                      context.read<HistoryBloc>().add(DeleteSelectedHistory()),
          ),
      ],
    );
  }

  void _confirmDeleteSingle(
    BuildContext context,
    AppLocalizations l10n,
    int newsId,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.confirm),
        content: Text(l10n.deleteHistory),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<HistoryBloc>().add(DeleteHistoryEvent(newsId));
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final DateTime readAt;

  const _HistoryCard({
    required this.title,
    required this.imageUrl,
    required this.readAt,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedImageUrl = resolveImageUrl(imageUrl);

    final formattedTime = DateFormat(
      'dd MMM yyyy, HH:mm',
    ).format(readAt.toLocal());

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(14),
            ),
            child: resolvedImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: resolvedImageUrl,
                    width: 110,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 110,
                      height: 80,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 110,
                      height: 80,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  )
                : Container(
                    width: 110,
                    height: 80,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formattedTime,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
