import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/comment_bloc.dart';
import '../bloc/comment_event.dart';
import '../bloc/comment_state.dart';
import 'comment_detail_page.dart';

class CommentListPage extends StatefulWidget {
  final int newsId;
  const CommentListPage({super.key, required this.newsId});

  @override
  State<CommentListPage> createState() => _CommentListPageState();
}

class _CommentListPageState extends State<CommentListPage> {
  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(LoadCommentsByNews(widget.newsId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CommentError) {
          return Center(child: Text(state.message));
        }

        if (state is CommentListLoaded) {
          final comments = state.comments;

          if (comments.isEmpty) {
            return const Center(child: Text("Belum ada komentar"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: comments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final comment = comments[index];

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== AVATAR =====
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: comment.userImage != null
                            ? NetworkImage(comment.userImage!)
                            : null,
                        backgroundColor: Colors.green.shade100,
                        child: comment.userImage == null
                            ? Text(
                                comment.userId != null
                                    ? comment.userId.toString()
                                    : '?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            : null,
                      ),

                      const SizedBox(width: 12),

                      // ===== CONTENT =====
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User ID
                            Text(
                              comment.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Komentar
                            Text(
                              comment.content,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 8),

                            // Aksi
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: const Icon(Icons.visibility),
                                label: const Text("Detail"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<CommentBloc>(),
                                        child: CommentDetailPage(
                                          commentId: comment.id,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
