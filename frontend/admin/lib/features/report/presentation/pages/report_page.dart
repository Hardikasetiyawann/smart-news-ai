import 'package:admin/features/comment/data/datasources/comment_remote_datasource.dart';
import 'package:admin/features/comment/data/repositories/comment_repository_impl.dart';
import 'package:admin/features/comment/domain/usecases/delete_comment.dart';
import 'package:admin/features/comment/domain/usecases/get_comment_by_id.dart';
import 'package:admin/features/comment/domain/usecases/get_comments_by_news.dart';
import 'package:admin/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../bloc/report_bloc.dart';
import '../bloc/report_event.dart';
import '../bloc/report_state.dart';

import '../../../news/presentation/pages/news_detail_page.dart';
import '../../../comment/presentation/pages/comment_detail_page.dart';
import '../../../../core/layout/admin_layout.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReportBloc>().add(LoadReports());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AdminLayout(
      child: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReportLoaded) {
            // ================= MOBILE =================
            if (width < 768) {
              return _buildMobile(context, state);
            }

            // ================= TABLET + DESKTOP =================
            return _buildTable(context, state, scrollHorizontal: width < 1200);
          }

          if (state is ReportError) {
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

  // ================= MOBILE VIEW =================
  Widget _buildMobile(BuildContext context, ReportLoaded state) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final r = state.reports[index];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TYPE + STATUS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      r.type.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      r.status,
                      style: TextStyle(
                        color: r.status == "pending"
                            ? Colors.orange
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // TARGET
                InkWell(
                  onTap: () => _openTarget(context, r),
                  child: Text(
                    r.type == "news"
                        ? "News ID: ${r.newsId}"
                        : "Comment ID: ${r.commentId}",
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // REASON
                Text(r.content, maxLines: 3, overflow: TextOverflow.ellipsis),

                const SizedBox(height: 12),

                // ACTIONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (r.status == "pending")
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          context.read<ReportBloc>().add(ResolveReport(r.id));
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<ReportBloc>().add(DeleteReportEvent(r.id));
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

  // ================= TABLE VIEW =================
  Widget _buildTable(
    BuildContext context,
    ReportLoaded state, {
    required bool scrollHorizontal,
  }) {
    final table = DataTable(
      columnSpacing: 24,
      columns: const [
        DataColumn(label: Text("Type")),
        DataColumn(label: Text("Target")),
        DataColumn(label: Text("Reason")),
        DataColumn(label: Text("Status")),
        DataColumn(label: Text("Action")),
      ],
      rows: state.reports.map((r) {
        return DataRow(
          cells: [
            DataCell(Text(r.type)),

            DataCell(
              InkWell(
                onTap: () => _openTarget(context, r),
                child: Text(
                  r.type == "news"
                      ? "News ID: ${r.newsId}"
                      : "Comment ID: ${r.commentId}",
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            DataCell(
              SizedBox(
                width: 280,
                child: Text(
                  r.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            DataCell(
              Text(
                r.status,
                style: TextStyle(
                  color: r.status == "pending" ? Colors.orange : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            DataCell(
              Row(
                children: [
                  if (r.status == "pending")
                    IconButton(
                      tooltip: "Resolve",
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        context.read<ReportBloc>().add(ResolveReport(r.id));
                      },
                    ),
                  IconButton(
                    tooltip: "Delete",
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<ReportBloc>().add(DeleteReportEvent(r.id));
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );

    return scrollHorizontal
        ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: table)
        : table;
  }

  // ================= OPEN TARGET =================
  void _openTarget(BuildContext context, dynamic r) {
    if (r.type == "news" && r.newsId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NewsDetailPage(newsId: r.newsId!)),
      );
    }

    if (r.type == "comment" && r.commentId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => CommentBloc(
              getByNews: GetCommentsByNews(
                CommentRepositoryImpl(CommentRemoteDataSource(http.Client())),
              ),
              getById: GetCommentById(
                CommentRepositoryImpl(CommentRemoteDataSource(http.Client())),
              ),
              deleteComment: DeleteComment(
                CommentRepositoryImpl(CommentRemoteDataSource(http.Client())),
              ),
            ),
            child: CommentDetailPage(commentId: r.commentId!),
          ),
        ),
      );
    }
  }
}
