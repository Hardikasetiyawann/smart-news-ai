import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/layout/app_scaffold.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/search_text_field.dart';
import '../widgets/search_news_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _currentQuery = '';

  void _onQueryChanged(String value) {
    setState(() {
      _currentQuery = value;
    });

    if (value.trim().isEmpty) {
      context.read<SearchNewsBloc>().add(SearchNewsCleared());
    } else {
      context.read<SearchNewsBloc>().add(
            SearchNewsRequested(value),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 1,
      appBar: AppBar(
        title: const Text('Search News'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchTextField(
              onChanged: _onQueryChanged,
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: BlocBuilder<SearchNewsBloc, SearchNewsState>(
                key: ValueKey(_currentQuery),
                builder: (context, state) {
                  if (state is SearchNewsInitial) {
                    return const Center(
                      child: Text('Ketik kata kunci berita'),
                    );
                  }

                  if (state is SearchNewsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is SearchNewsEmpty) {
                    return const Center(
                      child: Text('Berita tidak ditemukan'),
                    );
                  }

                  if (state is SearchNewsLoaded) {
                    return SearchNewsList(news: state.news);
                  }

                  if (state is SearchNewsError) {
                    return Center(
                      child: Text(state.message),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
