import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/app_bottom_nav.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final int currentIndex;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    required this.currentIndex,
  });

  // deteksi mobile atau bukan
  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 500;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    // cek apakah ada custom AppBar
    final bool hasCustomAppBar = appBar != null;

    return Scaffold(
      // jika ada custom AppBar, pakai itu
      // jika tidak ada, untuk mobile tidak pakai AppBar
      appBar: hasCustomAppBar
          ? appBar
          : isMobile
          ? null
          : AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              elevation: 0,
            ),

      // hanya tampilkan drawer di tablet/desktop
      drawer: isMobile ? null : const AppDrawer(),

      // hanya tampilkan bottom navigation di mobile
      bottomNavigationBar: isMobile
          ? AppBottomNav(currentIndex: currentIndex)
          : null,
      body: SafeArea(child: body),
    );
  }
}
