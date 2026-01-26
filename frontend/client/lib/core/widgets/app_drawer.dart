import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';

// Pages
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/bookmark/presentation/pages/bookmark_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    const aquaColor = Color(0xFF2DD4BF);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header logo dan nama app
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo/Frame.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Lens News',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: aquaColor,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // pilihan menu
            _item(
              context,
              icon: Icons.dashboard,
              label: l10n.drawerDashboard,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardPage()),
                );
              },
            ),

            _item(
              context,
              icon: Icons.search,
              label: l10n.drawerSearch,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                );
              },
            ),

            _item(
              context,
              icon: Icons.bookmark,
              label: l10n.drawerBookmarks,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const BookmarkPage()),
                );
              },
            ),

            _item(
              context,
              icon: Icons.person,
              label: l10n.drawerProfile,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),

            _item(
              context,
              icon: Icons.settings,
              label: l10n.drawerSettings,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // helper untuk membuat item menu

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(leading: Icon(icon), title: Text(label), onTap: onTap);
  }
}
