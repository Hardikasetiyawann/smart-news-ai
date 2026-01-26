import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/detail_remote_datasource.dart';
import '../../data/repositories/detail_repository_impl.dart';
import '../../domain/usecases/get_detail_news.dart';
import '../../domain/usecases/get_detail_ai_summary.dart';
import '../../domain/usecases/get_detail_interaction.dart';
import '../../domain/usecases/record_news_view.dart';
import '../bloc/detail_bloc.dart';
import '../bloc/detail_event.dart';
import '../pages/detail_page.dart';
import '../../../bookmark/data/datasources/bookmark_local_datasource.dart';
import '../../../bookmark/data/repositories/bookmark_repository_impl.dart';
import '../../../bookmark/domain/usecases/add_bookmark.dart';
import '../../../bookmark/domain/usecases/remove_bookmark.dart';
import '../../../bookmark/domain/usecases/is_bookmarked.dart';
import '../../../comments/data/datasources/comment_remote_datasource.dart';
import '../../../comments/data/repositories/comment_repository_impl.dart';
import '../../../comments/domain/usecase/get_comments.dart';
import '../../../comments/domain/usecase/add_comment.dart';
import '../../../comments/domain/usecase/update_comment.dart';
import '../../../comments/domain/usecase/delete_comment.dart';

class NewsDetailProvider extends StatelessWidget {
  final int newsId;

  const NewsDetailProvider({super.key, required this.newsId});

  @override
  Widget build(BuildContext context) {
    final detailRemote = DetailRemoteDataSource(dio: DioClient.dio);

    final detailRepository = DetailRepositoryImpl(
      remoteDataSource: detailRemote,
    );

    final commentRemote = CommentRemoteDataSource(dio: DioClient.dio);

    final commentRepository = CommentRepositoryImpl(
      remoteDataSource: commentRemote,
    );
    final bookmarkLocalDataSource = BookmarkLocalDataSourceImpl();

    final bookmarkRepository = BookmarkRepositoryImpl(bookmarkLocalDataSource);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => GetComments(commentRepository)),
        RepositoryProvider(create: (_) => AddComment(commentRepository)),
        RepositoryProvider(create: (_) => UpdateComment(commentRepository)),
        RepositoryProvider(create: (_) => DeleteComment(commentRepository)),
      ],
      child: BlocProvider(
        create: (_) => DetailBloc(
          getDetailNews: GetDetailNews(detailRepository),
          getDetailAiSummary: GetDetailAiSummary(detailRepository),
          getDetailInteraction: GetDetailInteraction(detailRepository),
          recordNewsView: RecordNewsView(detailRepository),
          addBookmark: AddBookmark(bookmarkRepository),
          removeBookmark: RemoveBookmark(bookmarkRepository),
          isBookmarked: IsBookmarked(bookmarkRepository),
        )..add(DetailLoadRequested(newsId)),
        child: DetailPage(newsId: newsId),
      ),
    );
  }
}

// navigasi ke halaman detail news
void goToNewsDetail(BuildContext context, int newsId) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, animation, __) {
        return FadeTransition(
          opacity: animation,
          child: NewsDetailProvider(newsId: newsId),
        );
      },
      transitionsBuilder: (_, animation, __, child) {
        final offsetTween = Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return SlideTransition(
          position: animation.drive(offsetTween),
          child: child,
        );
      },
    ),
  );
}
