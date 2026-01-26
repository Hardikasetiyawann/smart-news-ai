import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  final bool showSearch;
  final ValueChanged<String>? onSearch;

  const AdminLayout({
    super.key,
    required this.child,
    this.showSearch = false,
    this.onSearch,
  });

  String _getPageTitle(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name ?? '';

    switch (route) {
      case '/dashboard':
        return 'Dashboard';
      case '/news':
        return 'Kelola Berita';
      case '/category':
        return 'Kategori';
      case '/publisher':
        return 'Publisher';
      case '/report':
        return 'Laporan';
      case '/users':
        return 'Data User';
      case '/logs':
        return 'Log Aktivitas';
      case '/admin':
        return 'Admin Management';
      default:
        return 'Admin Panel';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      // ================= MOBILE DRAWER =================
      drawer: isMobile ? const Drawer(child: SafeArea(child: Sidebar())) : null,

      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= SIDEBAR =================
          if (!isMobile) const Sidebar(),

          // ================= MAIN CONTENT =================
          Expanded(
            child: Column(
              children: [
                // ================= TOP BAR =================
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== BARIS ATAS =====
                      Row(
                        children: [
                          if (isMobile)
                            Builder(
                              builder: (context) => IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                            ),

                          Text(
                            _getPageTitle(context),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // ===== SEARCH DESKTOP =====
                          if (!isMobile && showSearch) ...[
                            const Spacer(),
                            SizedBox(
                              width: 260,
                              height: 40,
                              child: _SearchField(onSearch: onSearch),
                            ),
                          ],
                        ],
                      ),

                      // ===== SEARCH MOBILE =====
                      if (isMobile && showSearch) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: _SearchField(onSearch: onSearch),
                        ),
                      ],
                    ],
                  ),
                ),

                // ================= PAGE CONTENT =================
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= SEARCH FIELD =================
class _SearchField extends StatelessWidget {
  final ValueChanged<String>? onSearch;

  const _SearchField({this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearch,
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: const Icon(Icons.search, size: 18),
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
