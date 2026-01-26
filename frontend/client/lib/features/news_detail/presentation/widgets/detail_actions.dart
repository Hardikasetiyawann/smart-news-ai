import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../comments/presentation/bloc/comment_bloc.dart';
import '../../../comments/presentation/bloc/comment_event.dart';
import '../../../comments/presentation/widgets/comment_drawer.dart';
import '../../../comments/domain/usecase/add_comment.dart';
import '../../../comments/domain/usecase/delete_comment.dart';
import '../../../comments/domain/usecase/get_comments.dart';
import '../../../comments/domain/usecase/update_comment.dart';

import '../bloc/detail_bloc.dart';
import '../bloc/detail_event.dart';
import '../bloc/detail_state.dart';

class DetailActions extends StatelessWidget {
  const DetailActions({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DetailBloc>().state;
    if (state is! DetailLoaded) return const SizedBox();

    final l10n = AppLocalizations.of(context);
    final interaction = state.interaction;
    final news = state.news;
    final int newsId = news.id;

    final isTablet = MediaQuery.of(context).size.width >= 500;

    final double barHeight = isTablet ? 56 : 44;
    final double iconSize = isTablet ? 26 : 22;
    final double fontSize = isTablet ? 14 : 12;
    final double horizontalPadding = isTablet ? 20 : 14;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: Container(
        height: barHeight,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ❤️ LIKE (ANIMATED)
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                context
                    .read<DetailBloc>()
                    .add(DetailToggleLike());
              },
              child: Row(
                children: [
                  _AnimatedToggleIcon(
                    active: interaction.isLiked,
                    activeIcon: Icons.favorite,
                    inactiveIcon: Icons.favorite_border,
                    size: iconSize,
                    activeColor: Colors.red,
                    inactiveColor: Colors.grey,
                    onTap: () {
                      context
                          .read<DetailBloc>()
                          .add(DetailToggleLike());
                    },
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${interaction.totalLikes}',
                    style: TextStyle(fontSize: fontSize),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // 💬 COMMENT (NO ANIMATION)
            _iconWithCount(
              icon: Icons.comment_outlined,
              count: interaction.totalComments,
              iconSize: iconSize,
              fontSize: fontSize,
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (modalContext) {
                    return BlocProvider(
                      create: (_) => CommentBloc(
                        getComments:
                            context.read<GetComments>(),
                        addComment:
                            context.read<AddComment>(),
                        updateComment:
                            context.read<UpdateComment>(),
                        deleteComment:
                            context.read<DeleteComment>(),
                      )..add(
                          CommentLoadRequested(newsId),
                        ),
                      child: CommentDrawer(
                        newsId: newsId,
                        onChanged: () {
                          context
                              .read<DetailBloc>()
                              .add(
                                  DetailReloadInteraction());
                        },
                      ),
                    );
                  },
                );
              },
            ),

            SizedBox(width: isTablet ? 32 : 24),

            // 🔖 BOOKMARK (ANIMATED)
            _AnimatedToggleIcon(
              active: interaction.isBookmarked,
              activeIcon: Icons.bookmark,
              inactiveIcon: Icons.bookmark_border,
              size: iconSize,
              activeColor: Colors.grey,
              inactiveColor: Colors.grey,
              onTap: () {
                context
                    .read<DetailBloc>()
                    .add(DetailToggleBookmark());
              },
            ),

            const SizedBox(width: 12),

            // 🤖 AI SUMMARY
            SizedBox(
              height: isTablet ? 38 : 32,
              child: OutlinedButton(
                onPressed: state.isLoadingAi
                    ? null
                    : () {
                        context
                            .read<DetailBloc>()
                            .add(
                                DetailToggleAiSummary());
                      },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 16 : 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),
                child: state.isLoadingAi
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2),
                      )
                    : Text(
                        l10n.detailAiSummary,
                        style:
                            TextStyle(fontSize: fontSize),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= COMMENT ICON =================
  Widget _iconWithCount({
    required IconData icon,
    required int count,
    required double iconSize,
    required double fontSize,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          Icon(
            icon,
            size: iconSize,
            color: Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}

// ================= ANIMATED ICON =================
class _AnimatedToggleIcon extends StatefulWidget {
  final bool active;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _AnimatedToggleIcon({
    required this.active,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.size,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  State<_AnimatedToggleIcon> createState() =>
      _AnimatedToggleIconState();
}

class _AnimatedToggleIconState
    extends State<_AnimatedToggleIcon> {
  double _scale = 1.0;

  void _handleTap() {
    // Trigger business logic (Bloc)
    widget.onTap();

    // POP animation hanya saat aktif = false → true
    if (!widget.active) {
      setState(() => _scale = 1.25);

      Future.delayed(const Duration(milliseconds: 120), () {
        if (mounted) {
          setState(() => _scale = 1.0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          opacity: widget.active ? 1.0 : 0.7,
          duration: const Duration(milliseconds: 140),
          child: Icon(
            widget.active
                ? widget.activeIcon
                : widget.inactiveIcon,
            size: widget.size,
            color: widget.active
                ? widget.activeColor
                : widget.inactiveColor,
          ),
        ),
      ),
    );
  }
}
