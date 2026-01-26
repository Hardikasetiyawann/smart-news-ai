import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';
import '../../domain/entities/comment_entity.dart';
import '../../../../core/utils/time_formatter.dart';

class CommentItem extends StatefulWidget {
  final CommentEntity comment;
  final void Function(String newContent)? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  const CommentItem({
    super.key,
    required this.comment,
    this.onEdit,
    this.onDelete,
    this.onReport,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isEditing = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.comment.content);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // avatar user
          CircleAvatar(
            radius: 16,
            backgroundImage: comment.user.imageUrl != null
                ? NetworkImage(comment.user.imageUrl!)
                : null,
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: comment.user.imageUrl == null
                ? Text(
                    comment.user.initial,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  )
                : null,
          ),

          const SizedBox(width: 12),

          // isi komentar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama + waktu
                Row(
                  children: [
                    Text(
                      comment.user.fullName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      TimeFormatter.timeAgo(comment.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Isi komentar / Edit mode
                if (isEditing)
                  TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 3,
                    autofocus: true,
                  )
                else
                  Text(comment.content),

                // Tombol edit
                if (isEditing)
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          final text = controller.text.trim();
                          if (text.isNotEmpty) {
                            widget.onEdit?.call(text);
                          }
                          setState(() => isEditing = false);
                        },
                        child: Text(l10n.commentSave),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.text = comment.content;
                          setState(() => isEditing = false);
                        },
                        child: Text(l10n.commentCancel),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // menu popup
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                setState(() => isEditing = true);
              } else if (value == 'delete') {
                _confirmDelete(context);
              } else if (value == 'report') {
                widget.onReport?.call();
              }
            },
            itemBuilder: (_) {
              if (comment.isMine) {
                return [
                  PopupMenuItem(value: 'edit', child: Text(l10n.commentEdit)),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(l10n.commentDelete),
                  ),
                ];
              }
              return [
                PopupMenuItem(value: 'report', child: Text(l10n.commentReport)),
              ];
            },
          ),
        ],
      ),
    );
  }

  // konfirmasi hapus komentar
  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.commentDeleteTitle),
        content: Text(l10n.commentDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commentNo),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete?.call();
            },
            child: Text(l10n.commentYes),
          ),
        ],
      ),
    );
  }
}
