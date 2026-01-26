import 'package:client/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:client/features/profile/presentation/pages/profile_page.dart';
import 'package:client/features/search/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../features/bookmark/presentation/pages/bookmark_page.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  void _navigate(BuildContext context, Widget page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha:0.6),

      onTap: (index) {
        if (index == currentIndex) return;

        // navigasi berdasarkan index
        switch (index) {
          case 0:
            _navigate(context, const DashboardPage());
            break;
          case 1:
            _navigate(context, const SearchPage());
            break;
          case 2:
            _navigate(context, const BookmarkPage());
            break;
          case 3:
            _navigate(context, const ProfilePage());
            break;
        }
      },

      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: l10n.navHome),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: l10n.navExplore,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: l10n.navBookmark,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: l10n.navProfile,
        ),
      ],
    );
  }
}
