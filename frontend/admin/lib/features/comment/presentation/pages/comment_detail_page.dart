import 'package:admin/core/layout/admin_layout.dart';
import 'package:admin/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:admin/features/comment/presentation/bloc/comment_event.dart';
import 'package:admin/features/comment/presentation/bloc/comment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CommentDetailPage extends StatefulWidget {
  final int commentId;
  const CommentDetailPage({super.key, required this.commentId});

  @override
  State<CommentDetailPage> createState() => _CommentDetailPageState();
}

class _CommentDetailPageState extends State<CommentDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(LoadCommentDetail(widget.commentId));
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      child: BlocConsumer<CommentBloc, CommentState>(
        listener: (context, state) {
          if (state is CommentError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is CommentDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Komentar berhasil dihapus")),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is CommentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CommentDetailLoaded) {
            final comment = state.comment;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== PAGE HEADER =====
                const Text(
                  "Detail Komentar",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // ===== CARD =====
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===== USER INFO =====
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: comment.userImage != null
                                  ? NetworkImage(comment.userImage!)
                                  : null,
                              backgroundColor: Colors.green.shade100,
                              child: comment.userImage == null
                                  ? Text(
                                      comment.userName.isNotEmpty
                                          ? comment.userName[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'dd MMM yyyy • HH:mm',
                                  ).format(comment.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(),

                        // ===== COMMENT CONTENT =====
                        Text(
                          "Isi Komentar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            comment.content,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ===== ACTION =====
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete),
                            label: const Text("Hapus Komentar"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Hapus Komentar"),
                                  content: const Text(
                                    "Apakah Anda yakin ingin menghapus komentar ini?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Batal"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Hapus"),
                                    ),
                                  ],
                                ),
                              );

                              if (!context.mounted) return;

                              if (confirm == true) {
                                context.read<CommentBloc>().add(
                                  DeleteCommentEvent(id: comment.id),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
