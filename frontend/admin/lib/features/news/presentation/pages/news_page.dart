import 'package:admin/core/layout/admin_layout.dart';
import 'package:admin/core/widgets/app_dialog.dart';
import 'package:admin/features/comment/data/datasources/comment_remote_datasource.dart';
import 'package:admin/features/comment/data/repositories/comment_repository_impl.dart';
import 'package:admin/features/comment/domain/usecases/delete_comment.dart';
import 'package:admin/features/comment/domain/usecases/get_comment_by_id.dart';
import 'package:admin/features/comment/domain/usecases/get_comments_by_news.dart';
import 'package:admin/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:admin/features/comment/presentation/pages/comment_list_page.dart';
import 'package:admin/features/news/presentation/pages/news_detail_page.dart';
import 'package:admin/features/publisher/presentation/bloc/publisher_bloc.dart';
import 'package:admin/features/publisher/presentation/bloc/publisher_state.dart';
import 'package:admin/features/news/presentation/bloc/ai_summary_status_bloc.dart';
import 'package:admin/features/news/presentation/bloc/ai_summary_status_event.dart';
import 'package:admin/features/news/presentation/bloc/ai_summary_status_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../../domain/entities/news.dart';
import 'create_news_page.dart';
import 'edit_news_page.dart';

/// ================= HELPER =================
String getPublisherName(int publisherId, PublisherState state) {
  if (state is PublisherLoaded) {
    try {
      return state.publishers.firstWhere((p) => p.id == publisherId).name;
    } catch (_) {
      return '-';
    }
  }
  return '-';
}

enum _NewsAction { view, edit, delete, comment }

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  // ================= PAGINATION =================
  static const int _pageSize = 8;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(LoadNewsEvent());
    context.read<AiSummaryStatusBloc>().add(LoadAiSummaryStatus());
  }

  int _totalPages(int total) {
    if (total <= 0) return 1;
    return (total / _pageSize).ceil();
  }

  List<News> _paginate(List<News> data) {
    final page = (_currentPage <= 0) ? 1 : _currentPage;
    final start = (page - 1) * _pageSize;

    if (start < 0 || start >= data.length) return [];

    final end = (start + _pageSize > data.length)
        ? data.length
        : start + _pageSize;

    return data.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocListener<PublisherBloc, PublisherState>(
      listenWhen: (prev, curr) => curr is PublisherLoaded && prev != curr,
      listener: (context, state) {
        final loaded = state as PublisherLoaded;
        final map = {for (var p in loaded.publishers) p.id: p.name};
        context.read<NewsBloc>().add(SetPublisherMap(map));
      },
      child: AdminLayout(
        showSearch: true,
        onSearch: (keyword) {
          setState(() => _currentPage = 1);
          context.read<NewsBloc>().add(SearchNewsEvent(keyword));
        },
        child: BlocConsumer<NewsBloc, NewsState>(
          listener: (context, state) {
            if (state is NewsSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is NewsError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is NewsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NewsLoaded) {
              final publisherState = context.watch<PublisherBloc>().state;
              final totalPages = _totalPages(state.news.length);

              if (_currentPage > totalPages) {
                _currentPage = 1;
              }

              final pagedNews = _paginate(state.news);

              // 📱 MOBILE + TABLET
              if (width < 1340) {
                return Column(
                  children: [
                    Expanded(
                      child: _buildMobileList(
                        context,
                        pagedNews,
                        publisherState,
                      ),
                    ),
                    _PaginationBar(
                      currentPage: _currentPage,
                      totalPages: totalPages,
                      onChanged: (p) => setState(() => _currentPage = p),
                    ),
                  ],
                );
              }

              // 🖥️ DESKTOP
              return Column(
                children: [
                  Expanded(
                    child: _buildTable(context, pagedNews, publisherState),
                  ),
                  _PaginationBar(
                    currentPage: _currentPage,
                    totalPages: totalPages,
                    onChanged: (p) => setState(() => _currentPage = p),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // ================= MOBILE & TABLET LIST =================
  Widget _buildMobileList(
    BuildContext context,
    List<News> news,
    PublisherState publisherState,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: news.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Manajemen News",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateNewsPage()),
                  );
                },
                child: const Text("Tambah"),
              ),
            ],
          );
        }

        final item = news[index - 1];

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "${getPublisherName(item.publisherId, publisherState)} • ${item.status}",
            ),

            // ================= TITIK TIGA =================
            trailing: PopupMenuButton<_NewsAction>(
              icon: const Icon(Icons.more_vert),
              onSelected: (action) async {
                switch (action) {
                  case _NewsAction.view:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AdminLayout(child: NewsDetailPage(newsId: item.id)),
                      ),
                    );
                    break;

                  case _NewsAction.edit:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditNewsPage(news: item),
                      ),
                    );
                    break;

                  case _NewsAction.comment:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => CommentBloc(
                            getByNews: GetCommentsByNews(
                              CommentRepositoryImpl(
                                CommentRemoteDataSource(http.Client()),
                              ),
                            ),
                            getById: GetCommentById(
                              CommentRepositoryImpl(
                                CommentRemoteDataSource(http.Client()),
                              ),
                            ),
                            deleteComment: DeleteComment(
                              CommentRepositoryImpl(
                                CommentRemoteDataSource(http.Client()),
                              ),
                            ),
                          ),
                          child: AdminLayout(
                            child: CommentListPage(newsId: item.id),
                          ),
                        ),
                      ),
                    );
                    break;

                  case _NewsAction.delete:
                    final confirm = await AppDialog.showConfirm(
                      context,
                      title: "Hapus News",
                      message: "Apakah kamu yakin ingin menghapus news ini?",
                      confirmText: "Hapus",
                      cancelText: "Batal",
                    );

                    if (!context.mounted) return;

                    if (confirm) {
                      context.read<NewsBloc>().add(DeleteNewsEvent(item.id));
                    }
                    break;
                }
              },

              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _NewsAction.view,
                  child: ListTile(
                    leading: Icon(Icons.visibility),
                    title: Text("Lihat"),
                  ),
                ),
                PopupMenuItem(
                  value: _NewsAction.edit,
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text("Edit"),
                  ),
                ),
                PopupMenuItem(
                  value: _NewsAction.comment,
                  child: ListTile(
                    leading: Icon(Icons.comment),
                    title: Text("Komentar"),
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: _NewsAction.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text("Hapus", style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= DESKTOP TABLE =================
  Widget _buildTable(
    BuildContext context,
    List<News> news,
    PublisherState publisherState,
  ) {
    final aiState = context.watch<AiSummaryStatusBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Manajemen News",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateNewsPage()),
                );
              },
              child: const Text("Tambah News"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: DataTable(
                columnSpacing: 24,
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
                columns: const [
                  DataColumn(label: Text("Judul")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("AI Summary")),
                  DataColumn(label: Text("Publisher")),
                  DataColumn(label: SizedBox(width: 160, child: Text("Aksi"))),
                ],
                rows: news.map((item) {
                  final summarized = aiState is AiSummaryStatusLoaded
                      ? aiState.statusMap[item.id] ?? false
                      : false;

                  return DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 520,
                          child: Text(
                            item.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(Text(item.status)),
                      DataCell(
                        Chip(
                          label: Text(
                            summarized ? 'Summarized' : 'Not yet',
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: summarized
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                        ),
                      ),
                      DataCell(
                        Text(
                          getPublisherName(item.publisherId, publisherState),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AdminLayout(
                                      child: NewsDetailPage(newsId: item.id),
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditNewsPage(news: item),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await AppDialog.showConfirm(
                                  context,
                                  title: "Hapus News",
                                  message:
                                      "Apakah kamu yakin ingin menghapus news ini?",
                                  confirmText: "Hapus",
                                  cancelText: "Batal",
                                );
                                if (!context.mounted) return;
                                if (confirm) {
                                  context.read<NewsBloc>().add(
                                    DeleteNewsEvent(item.id),
                                  );
                                }
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.comment),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (_) => CommentBloc(
                                        getByNews: GetCommentsByNews(
                                          CommentRepositoryImpl(
                                            CommentRemoteDataSource(
                                              http.Client(),
                                            ),
                                          ),
                                        ),
                                        getById: GetCommentById(
                                          CommentRepositoryImpl(
                                            CommentRemoteDataSource(
                                              http.Client(),
                                            ),
                                          ),
                                        ),
                                        deleteComment: DeleteComment(
                                          CommentRepositoryImpl(
                                            CommentRemoteDataSource(
                                              http.Client(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: AdminLayout(
                                        child: CommentListPage(newsId: item.id),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ================= PAGINATION BAR =================
class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onChanged;

  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: currentPage > 1
                ? () => onChanged(currentPage - 1)
                : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Page $currentPage of $totalPages",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages
                ? () => onChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
