import 'package:flutter/material.dart';

import '../screens/browse/search_screen.dart';
import '../screens/chat/chats_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_bottom_nav.dart';

/// Central, reusable layout for the authenticated part of the app.
///
/// Owns the navigation drawer, the shared bottom navigation bar and the four
/// main tabs (Home, Search, Chats, Profile) in a lazily-built [IndexedStack],
/// so:
///
/// * navigation is managed in ONE place — no screen builds its own nav bar,
/// * tab switching never stacks duplicate screen instances,
/// * each visited tab keeps its state (scroll position, typed text, etc.),
/// * a tab is only built when first visited, preserving screens' `initState`
///   behaviour (e.g. the Search filter sheet opening when that tab is opened).
///
/// Authentication screens and feature flows (report wizard, item journeys,
/// chat details, settings, …) remain separate routes pushed on top of this
/// shell, so the back button naturally returns to it.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  /// Switches the shell to a main tab.
  ///
  /// [tabIndex]: 0 Home, 1 Search, 2 Chats, 3 Profile.
  ///
  /// When called from a screen stacked above the shell (a secondary screen
  /// showing the shared bottom bar), the routes above the shell are popped
  /// first — the shell is always the first route of the authenticated stack —
  /// so tab destinations never create duplicate screen instances.
  static void goToTab(BuildContext context, int tabIndex) {
    final shell = _MainShellState._instance;
    if (shell == null || !shell.mounted) {
      // Defensive fallback: no live shell, open a fresh one.
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
    shell.selectTab(tabIndex);
  }

  /// Opens the central navigation drawer from any authenticated screen.
  ///
  /// Screens stacked above the shell are popped back to it first, so the
  /// drawer is always presented on top of the shell.
  static void openDrawerFrom(BuildContext context) {
    final shell = _MainShellState._instance;
    if (shell == null || !shell.mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    shell.openDrawer();
  }

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static _MainShellState? _instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Tab order: 0 Home, 1 Search, 2 Chats, 3 Profile.
  int _currentTab = 0;

  /// Tabs are built lazily — a screen only mounts the first time its tab is
  /// selected, and then stays alive inside the IndexedStack.
  final List<bool> _built = [true, false, false, false];

  @override
  void initState() {
    super.initState();
    _instance = this;
  }

  @override
  void dispose() {
    if (_instance == this) _instance = null;
    super.dispose();
  }

  /// Selects the main tab with the given index (0–3).
  void selectTab(int tabIndex) {
    if (!mounted) return;
    if (tabIndex < 0 || tabIndex > 3) return;
    if (tabIndex == _currentTab) return;
    setState(() {
      _currentTab = tabIndex;
      _built[tabIndex] = true;
    });
  }

  /// Opens the shell's navigation drawer.
  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF8F9FD);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: background,
      drawer: AppDrawer(currentTab: _currentTab),
      body: IndexedStack(
        index: _currentTab,
        children: [
          if (_built[0]) const HomeScreen() else const SizedBox.shrink(),
          if (_built[1]) const SearchScreen() else const SizedBox.shrink(),
          if (_built[2]) const ChatsScreen() else const SizedBox.shrink(),
          if (_built[3]) const ProfileScreen() else const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _slotForTab(_currentTab),
      ),
    );
  }

  /// Maps shell tabs (0–3) to the five bottom bar slots
  /// (0 Home, 1 Search, 2 Report, 3 Chats, 4 Profile).
  static int _slotForTab(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return 1; // Search
      case 2:
        return 3; // Chats
      case 3:
        return 4; // Profile
      default:
        return 0; // Home
    }
  }
}
