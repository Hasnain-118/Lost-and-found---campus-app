import 'package:flutter/material.dart';

import '../navigation/main_shell.dart';

/// Shared hamburger menu button that opens the central navigation drawer.
///
/// Used in app bars and custom headers of every authenticated screen so the
/// drawer is reachable from anywhere in the app.
class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const ValueKey('app_menu_button'),
      icon: const Icon(Icons.menu_rounded, color: Color(0xFF182237)),
      tooltip: 'Open menu',
      onPressed: () => MainShell.openDrawerFrom(context),
    );
  }
}
