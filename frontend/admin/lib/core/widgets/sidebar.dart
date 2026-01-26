import 'package:admin/core/storage/auth_storage.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Column(
        children: [
          // ================= HEADER + MENU =================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // ================= BRAND =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'LensTeam',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E5C48),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Admin Panel',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  _SidebarItem(
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    route: '/dashboard',
                    isActive: currentRoute == '/dashboard',
                  ),
                  _SidebarItem(
                    icon: Icons.article_rounded,
                    title: 'Kelola Berita',
                    route: '/news',
                    isActive: currentRoute == '/news',
                  ),
                  _SidebarItem(
                    icon: Icons.category_rounded,
                    title: 'Kategori',
                    route: '/category',
                    isActive: currentRoute == '/category',
                  ),
                  _SidebarItem(
                    icon: Icons.business_rounded,
                    title: 'Publisher',
                    route: '/publisher',
                    isActive: currentRoute == '/publisher',
                  ),
                  _SidebarItem(
                    icon: Icons.report_problem_rounded,
                    title: 'Laporan',
                    route: '/report',
                    isActive: currentRoute == '/report',
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Divider(),
                  ),

                  _SidebarItem(
                    icon: Icons.smart_toy_rounded,
                    title: 'AI Summary',
                    route: '/ai-summary',
                    isActive: currentRoute == '/ai-summary',
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Divider(),
                  ),

                  _SidebarItem(
                    icon: Icons.people_alt_rounded,
                    title: 'Data User',
                    route: '/users',
                    isActive: currentRoute == '/users',
                  ),
                  _SidebarItem(
                    icon: Icons.history_rounded,
                    title: 'Log Aktivitas',
                    route: '/logs',
                    isActive: currentRoute == '/logs',
                  ),
                  _SidebarItem(
                    icon: Icons.admin_panel_settings_rounded,
                    title: 'Admin Management',
                    route: '/admin',
                    isActive: currentRoute == '/admin',
                  ),
                ],
              ),
            ),
          ),

          // ================= FOOTER =================
          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: FutureBuilder<String?>(
                    future: AuthStorage.getAdminName(),
                    builder: (context, snapshot) {
                      final name = snapshot.data ?? 'Admin';

                      return Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFF2E5C48),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Admin',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // ================= LOGOUT =================
                IconButton(
                  tooltip: 'Logout',
                  icon: const Icon(Icons.logout, size: 18, color: Colors.grey),
                  onPressed: () async {
                    final navigator = Navigator.of(context); // ✅ SIMPAN DULU

                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Apakah Anda yakin ingin logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await AuthStorage.clear();
                      navigator.pushNamedAndRemoveUntil(
                        '/login',
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= SIDEBAR ITEM =================
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final bool isActive;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final scaffold = Scaffold.maybeOf(context);
        if (scaffold != null && scaffold.isDrawerOpen) {
          Navigator.pop(context);
        }

        if (!isActive) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF2E5C48).withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? const Border(
                  left: BorderSide(color: Color(0xFF2E5C48), width: 4),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? const Color(0xFF2E5C48) : Colors.grey[600],
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? const Color(0xFF2E5C48) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
