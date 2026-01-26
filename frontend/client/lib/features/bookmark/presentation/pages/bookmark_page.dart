import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/gen_l10n/app_localizations.dart';


import '../../../../core/layout/app_scaffold.dart';
import '../bloc/bookmark_bloc.dart';
import '../bloc/bookmark_event.dart';
import '../bloc/bookmark_state.dart';
import '../widgets/bookmark_list.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookmarkBloc>().add(LoadBookmarks());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      currentIndex: 2, 
      appBar: AppBar(
        title: Text('Bookmarks'),
         automaticallyImplyLeading: false,
    leading: MediaQuery.of(context).size.width >= 500
        ? Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          )
        : null,
  ),
      body: BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.bookmarks.isEmpty) {
            return Center(
              child: Text(
                l10n.bookmarkEmpty,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return BookmarkList(bookmarks: state.bookmarks);
        },
      ),
    );
  }
}
