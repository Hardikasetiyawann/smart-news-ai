import 'package:flutter/material.dart';

// Widget untuk tombol burger (menu)
class BurgerButton extends StatelessWidget {
  const BurgerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}
