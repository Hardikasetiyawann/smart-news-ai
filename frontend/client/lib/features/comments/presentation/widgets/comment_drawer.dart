import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../reports/presentation/bloc/report_bloc.dart';
import '../../../reports/presentation/pages/report_page.dart';
import '../bloc/comment_bloc.dart';
import '../bloc/comment_event.dart';
import '../bloc/comment_state.dart';
import 'comment_item.dart';

class CommentDrawer extends StatefulWidget {
  final int newsId;
  final VoidCallback onChanged;

  const CommentDrawer({
    super.key,
    required this.newsId,
    required this.onChanged,
  });

  @override
  State<CommentDrawer> createState() => _CommentDrawerState();
}

class _CommentDrawerState extends State<CommentDrawer> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<CommentBloc>().add(CommentLoadRequested(widget.newsId));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return AnimatedPadding(
          duration: const Duration(milliseconds: 50),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Text(
                  l10n.commentTitle,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // list komentar
                Expanded(
                  child: BlocConsumer<CommentBloc, CommentState>(
                    listener: (context, state) {
                      if (state is CommentLoaded) {
                        widget.onChanged();
                      }
                    },
                    builder: (context, state) {
                      if (state is CommentLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is CommentLoaded) {
                        if (state.comments.isEmpty) {
                          return Center(child: Text(l10n.commentEmpty));
                        }
                        // tampilkan daftar komentar
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: state.comments.length,
                          itemBuilder: (_, i) {
                            final comment = state.comments[i];
                            // widget komentar
                            return CommentItem(
                              comment: comment,

                              // edit komentar
                              onEdit: (newContent) {
                                context.read<CommentBloc>().add(
                                  CommentUpdateRequested(
                                    commentId: comment.id,
                                    content: newContent,
                                  ),
                                );
                              },
                              // hapus komentar
                              onDelete: () {
                                context.read<CommentBloc>().add(
                                  CommentDeleteRequested(comment.id),
                                );
                              },

                              // laporkan komentar
                              onReport: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (context) => ReportBloc(
                                        createReport: context
                                            .read(), // CreateReport usecase
                                      ),
                                      child: ReportPage(
                                        type: 'comment',
                                        commentId: comment.id,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }

                      if (state is CommentError) {
                        return Center(child: Text(state.message));
                      }

                      return const SizedBox();
                    },
                  ),
                ),

                const Divider(),

                // input komentar baru
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: l10n.commentHint,
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final text = _controller.text.trim();
                        if (text.isEmpty) return;

                        context.read<CommentBloc>().add(
                          CommentAddRequested(
                            newsId: widget.newsId,
                            content: text,
                          ),
                        );

                        _controller.clear();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
