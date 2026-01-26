import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/detail_bloc.dart';
import '../bloc/detail_state.dart';

import '../widgets/detail_appbar.dart';
import '../widgets/detail_image.dart';
import '../widgets/detail_header.dart';
import '../widgets/detail_actions.dart';
import '../widgets/detail_content_responsive.dart';

class DetailPage extends StatelessWidget {
  final int newsId;

  const DetailPage({
    super.key,
    required this.newsId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DetailError) {
              return Center(child: Text(state.message));
            }

            if (state is DetailLoaded) {
              final isTablet =
                  MediaQuery.of(context).size.width >= 500;

              return Stack(
                children: [
                  Column(
                    children: [
                      DetailAppBar(newsId: state.news.id),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 120),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetailImage(imageUrl: state.news.imageUrl),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 64 : 16,
                                  vertical: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    DetailHeader(news: state.news),
                                    const SizedBox(height: 16),
                                    DetailContentResponsive(
                                      content: state.displayedContent,
                                      linkNews: state.news.linkNews,
                                      isTablet: isTablet,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: isTablet ? 32 : 16,
                    left: 0,
                    right: 0,
                    child: const Center(
                      child: DetailActions(),
                    ),
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
}
