import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/publisher_remote_datasource.dart';
import '../../data/repositories/publisher_repository_impl.dart';
import '../../domain/usecases/get_news_by_publisher.dart';
import '../../../news_detail/presentation/navigation/detail_navigation.dart';

import '../bloc/publisher_bloc.dart';
import '../bloc/publisher_event.dart';
import '../bloc/publisher_state.dart';

import '../widgets/publisher_news_list_widget.dart';

class PublisherPage extends StatelessWidget {
  final int publisherId;
  final String publisherName;

  const PublisherPage({
    super.key,
    required this.publisherId,
    required this.publisherName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final remote = PublisherRemoteDataSource();
        final repository = PublisherRepositoryImpl(remote);

        return PublisherBloc(getNewsByPublisher: GetNewsByPublisher(repository))
          ..add(LoadPublisherNews(publisherId));
      },
      child: Scaffold(
        appBar: AppBar(title: Text(publisherName)),
        body: BlocBuilder<PublisherBloc, PublisherState>(
          builder: (context, state) {
            if (state is PublisherLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PublisherError) {
              return Center(child: Text(state.message));
            }

            if (state is PublisherLoaded) {
              if (state.news.isEmpty) {
                return const Center(
                  child: Text('Tidak ada berita dari publisher ini'),
                );
              }

              final items = state.news
                  .map(
                    (e) => NewsListItem(
                      id: e.id,
                      title: e.title,
                      imageUrl: e.imageUrl,
                      publishedAt: e.publishedAt,
                      countView: e.countView,
                    ),
                  )
                  .toList();

              return NewsListWidget(
                news: items,
                onTap: (newsId) {
                  goToNewsDetail(context, newsId);
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
